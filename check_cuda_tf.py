import tensorflow as tf

def check_gpu_availability():
  """Checks if a GPU is available for TensorFlow computations.

  Returns:
      A boolean indicating GPU availability.
      A string containing the name of the GPU device, if available.
  """

  physical_devices = tf.config.list_physical_devices('GPU')
  logical_devices = tf.config.list_logical_devices('GPU')

  if len(physical_devices) > 0:
    # There are physical GPUs present
    print("Physical GPUs found:")
    for device in physical_devices:
      print(f"\t- {device.name}")

    if len(logical_devices) > 0:
      # TensorFlow can access some of the physical GPUs
      print("Logical GPUs enabled:")
      for device in logical_devices:
        print(f"\t- {device.name}")
      return True, logical_devices[0].name  # Return first logical device name
    else:
      # TensorFlow cannot access the physical GPUs, likely due to resource constraints
      print("Logical GPUs not enabled - TensorFlow may not be able to access the GPUs.")
      return True, None  # Indicate GPU presence but no logical access
  else:
    # No physical GPUs available
    print("No GPUs found.")
    return False, None

if __name__ == "__main__":
  gpu_available, gpu_name = check_gpu_availability()
  if gpu_available:
    print("You can leverage GPU acceleration for TensorFlow computations.")
    if gpu_name:
      print(f"GPU device name: {gpu_name}")
  else:
    print("TensorFlow will use CPU for computations.")

