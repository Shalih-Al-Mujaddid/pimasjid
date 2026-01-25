import { ref, onMounted } from 'vue';

export function usePrayerTimes(initialTimes) {
    const currentPrayerTimes = ref(initialTimes);
    const isLocating = ref(false);
    const usingUserLocation = ref(false);
    const locationError = ref(null);

    const fetchPrayerTimes = async (lat, long) => {
        isLocating.value = true;
        try {
            const response = await fetch(`/api/public/prayer-times?latitude=${lat}&longitude=${long}`);
            if (!response.ok) throw new Error('Network response was not ok');

            const data = await response.json();
            currentPrayerTimes.value = data;
            usingUserLocation.value = true;
        } catch (error) {
            console.error('Error fetching prayer times:', error);
            locationError.value = 'Gagal memuat jadwal lokasi.';
        } finally {
            isLocating.value = false;
        }
    };

    const getUserLocation = () => {
        if (!navigator.geolocation) return;

        isLocating.value = true;
        locationError.value = null;

        navigator.geolocation.getCurrentPosition(
            (position) => {
                fetchPrayerTimes(position.coords.latitude, position.coords.longitude);
            },
            (err) => {
                isLocating.value = false;
                console.log('Location access denied or error:', err);
            }
        );
    };

    onMounted(() => {
        getUserLocation();
    });

    return {
        currentPrayerTimes,
        isLocating,
        usingUserLocation,
        locationError,
        getUserLocation
    };
}
