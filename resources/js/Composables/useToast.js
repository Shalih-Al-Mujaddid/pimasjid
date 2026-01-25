import { ref } from 'vue';

export function useToast() {
    const show = ref(false);
    const message = ref('');
    const type = ref('success'); // success, error, info, warning

    let timeout = null;

    const showToast = (msg, toastType = 'success', duration = 3000) => {
        message.value = msg;
        type.value = toastType;
        show.value = true;

        if (timeout) clearTimeout(timeout);

        timeout = setTimeout(() => {
            show.value = false;
        }, duration);
    };

    const success = (msg, duration) => showToast(msg, 'success', duration);
    const error = (msg, duration) => showToast(msg, 'error', duration);
    const info = (msg, duration) => showToast(msg, 'info', duration);
    const warning = (msg, duration) => showToast(msg, 'warning', duration);

    return {
        show,
        message,
        type,
        success,
        error,
        info,
        warning,
    };
}
