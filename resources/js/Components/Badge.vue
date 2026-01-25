<script setup>
import { computed } from 'vue';

const props = defineProps({
    variant: {
        type: String,
        default: 'neutral',
        validator: (value) => ['success', 'warning', 'danger', 'info', 'neutral', 'primary'].includes(value),
    },
    size: {
        type: String,
        default: 'md',
        validator: (value) => ['sm', 'md', 'lg'].includes(value),
    },
    dot: {
        type: Boolean,
        default: false,
    },
    rounded: {
        type: Boolean,
        default: true,
    },
});

const variantClasses = computed(() => {
    const variants = {
        success: 'bg-emerald-100 text-emerald-800 border-emerald-200',
        warning: 'bg-amber-100 text-amber-800 border-amber-200',
        danger: 'bg-red-100 text-red-800 border-red-200',
        info: 'bg-blue-100 text-blue-800 border-blue-200',
        neutral: 'bg-slate-100 text-slate-800 border-slate-200',
        primary: 'bg-primary-100 text-primary-800 border-primary-200',
    };
    return variants[props.variant];
});

const sizeClasses = computed(() => {
    const sizes = {
        sm: 'text-xs px-2 py-0.5',
        md: 'text-sm px-3 py-1',
        lg: 'text-base px-4 py-1.5',
    };
    return sizes[props.size];
});

const dotColorClasses = computed(() => {
    const colors = {
        success: 'bg-emerald-600',
        warning: 'bg-amber-600',
        danger: 'bg-red-600',
        info: 'bg-blue-600',
        neutral: 'bg-slate-600',
        primary: 'bg-primary-600',
    };
    return colors[props.variant];
});

const badgeClasses = computed(() => {
    return [
        'inline-flex items-center gap-1.5 font-semibold border',
        props.rounded ? 'rounded-full' : 'rounded-md',
        sizeClasses.value,
        variantClasses.value,
    ].join(' ');
});
</script>

<template>
    <span :class="badgeClasses">
        <span v-if="dot" :class="['w-2 h-2 rounded-full', dotColorClasses]"></span>
        <slot />
    </span>
</template>
