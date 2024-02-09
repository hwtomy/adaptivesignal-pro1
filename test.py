import numpy as np
from scipy.io import wavfile
from scipy.signal import lfilter, periodogram, hann, lfilter_zi
from scipy.linalg import solve_toeplitz, toeplitz
import matplotlib.pyplot as plt

# Read the audio file
fs, z = wavfile.read('F:\\signal process\\adaptive signal\\EQ2401_Project_1_2024\EQ2401project1data2024.wav')
# Ensure signal is in float format
z = z.astype(np.float64) / np.max(np.abs(z))

# Define variables
thre = 0.18
N = len(z)
ord_ar = 9  # AR model order

# Detect silent parts of the signal
silent = np.abs(z) < thre
noisees = z[silent]

# Calculate the variance of the noise
varnoise = np.var(noisees)

# Autocorrelation of noise
r = np.correlate(noisees, noisees, mode='full')
mid = len(r) // 2
r = r[mid:mid + ord_ar + 1] / len(noisees)  # Normalize autocorrelation

# Solve Yule-Walker Equations
R = toeplitz(r[:-1])  # Autocorrelation matrix
rhs = r[1:]
ar_coeffs = solve_toeplitz((r[:-1], r[:-1]), rhs)

# Ensure AR coefficients are in float format and include the leading 1
ar_coeffs = np.concatenate(([1.0], -ar_coeffs)).astype(np.float64)

# Generate white noise
v = np.random.randn(len(z)).astype(np.float64)

# Initial conditions for the filter
zi = lfilter_zi(1, ar_coeffs) * v[0]

# Filter the noise with the AR model to simulate noise
v, _ = lfilter([1.0], ar_coeffs, v, zi=zi)

# Adjust the variance of the generated noise
cvar = np.var(v)
v = v * np.sqrt(varnoise / cvar)

# Assuming a simple filtering operation for demonstration; replace with your actual filtering process
filtered_z = lfilter([1.0], ar_coeffs, z)  # Example filtering operation

# Create the window explicitly
window = hann(N, sym=False)

# Plotting the periodogram (example for the original signal)
f_orig, Pxx_orig = periodogram(z, fs, window=window, scaling='density')
f_filt, Pxx_filt = periodogram(filtered_z, fs, window=window, scaling='density')

plt.figure()
plt.plot(f_orig, 10 * np.log10(Pxx_orig), label='Original')
plt.plot(f_filt, 10 * np.log10(Pxx_filt), label='Filtered')
plt.legend()
plt.xlabel('Frequency [Hz]')
plt.ylabel('Power/Frequency [dB/Hz]')
plt.title('Periodogram Comparison')
plt.show()