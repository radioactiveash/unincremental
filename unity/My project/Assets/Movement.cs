using UnityEngine;

// Attach directly to your Camera. WASD + mouse look, Q/E for down/up,
// Shift to boost. Escape toggles cursor lock. Scroll wheel = smooth FOV zoom.
[RequireComponent(typeof(Camera))]
public class NoclipCamera : MonoBehaviour
{
    [Header("Movement")]
    public float moveSpeed = 10f;
    public float boostMultiplier = 3f;
    public float movementSmoothTime = 0.15f;

    [Header("Look")]
    public float lookSensitivity = 2f;
    public float lookSmoothTime = 0.05f;

    [Header("FOV")]
    public float minFOV = 20f;
    public float maxFOV = 90f;
    public float fovScrollSensitivity = 10f;
    public float fovSmoothTime = 0.15f;

    private Camera cam;

    // movement smoothing
    private Vector3 currentVelocity;
    private Vector3 velocityRef;

    // look smoothing (raw target angles vs. displayed angles)
    private float yaw, pitch;
    private float currentYaw, currentPitch;
    private float yawVelRef, pitchVelRef;

    // fov smoothing
    private float targetFOV;
    private float fovVelRef;

    void Start()
    {
        cam = GetComponent<Camera>();
        targetFOV = cam.fieldOfView;

        Vector3 angles = transform.eulerAngles;
        yaw = currentYaw = angles.y;
        pitch = currentPitch = angles.x;

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    void Update()
    {
        HandleLook();
        HandleMovement();
        HandleFOV();

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            bool locked = Cursor.lockState == CursorLockMode.Locked;
            Cursor.lockState = locked ? CursorLockMode.None : CursorLockMode.Locked;
            Cursor.visible = locked;
        }

        // Re-capture the cursor on click once it's been freed
        if (Cursor.lockState != CursorLockMode.Locked && Input.GetMouseButtonDown(0))
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }

    void HandleLook()
    {
        if (Cursor.lockState != CursorLockMode.Locked) return;

        yaw += Input.GetAxis("Mouse X") * lookSensitivity;
        pitch -= Input.GetAxis("Mouse Y") * lookSensitivity;
        pitch = Mathf.Clamp(pitch, -89f, 89f);

        // SmoothDampAngle handles the 0/360 wrap correctly
        currentYaw = Mathf.SmoothDampAngle(currentYaw, yaw, ref yawVelRef, lookSmoothTime);
        currentPitch = Mathf.SmoothDampAngle(currentPitch, pitch, ref pitchVelRef, lookSmoothTime);

        transform.rotation = Quaternion.Euler(currentPitch, currentYaw, 0f);
    }

    void HandleMovement()
    {
        Vector3 input = new Vector3(
            Input.GetAxisRaw("Horizontal"), // A/D
            0f,
            Input.GetAxisRaw("Vertical")    // W/S
        );

        if (Input.GetKey(KeyCode.E)) input.y += 1f;
        if (Input.GetKey(KeyCode.Q)) input.y -= 1f;

        input = Vector3.ClampMagnitude(input, 1f);

        float speed = moveSpeed * (Input.GetKey(KeyCode.LeftShift) ? boostMultiplier : 1f);
        Vector3 targetVelocity = transform.TransformDirection(input) * speed;

        currentVelocity = Vector3.SmoothDamp(currentVelocity, targetVelocity, ref velocityRef, movementSmoothTime);
        transform.position += currentVelocity * Time.deltaTime;
    }

    void HandleFOV()
    {
        float scroll = Input.mouseScrollDelta.y;
        targetFOV -= scroll * fovScrollSensitivity;
        targetFOV = Mathf.Clamp(targetFOV, minFOV, maxFOV);

        cam.fieldOfView = Mathf.SmoothDamp(cam.fieldOfView, targetFOV, ref fovVelRef, fovSmoothTime);
    }
}