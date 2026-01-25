<script setup>
import { computed } from 'vue';
import { ArrowTrendingUpIcon, ArrowTrendingDownIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
    title: {
        type: String,
        required: true,
    },
    value: {
        type: [String, Number],
        required: true,
    },
    trend: {
        type: String,
        default: 'neutral',
        validator: (value) => ['up', 'down', 'neutral'].includes(value),
    },
    percentage: {
        type: [String, Number],
        default: null,
    },
    color: {
        type: String,
        default: 'emerald',
        validator: (value) => ['emerald', 'amber', 'slate', 'blue'].includes(value),
    },
    subtitle: {
        type: String,
        default: null,
    },
});

const colorClasses = computed(() => {
    const colors = {
        emerald: {
            bg: 'bg-primary-100',
            icon: 'text-primary-600',
            gradient: 'bg-gradient-islamic',
        },
        amber: {
            bg: 'bg-secondary-100',
            icon: 'text-secondary-600',
            gradient: 'bg-gradient-gold',
        },
        slate: {
            bg: 'bg-slate-100',
            icon: 'text-slate-600',
            gradient: 'bg-gradient-to-r from-slate-600 to-slate-700',
        },
        blue: {
            bg: 'bg-blue-100',
            icon: 'text-blue-600',
            gradient: 'bg-gradient-to-r from-blue-600 to-blue-700',
        },
    };
    return colors[props.color];
});

const trendIcon = computed(() => {
    return props.trend === 'up' ? ArrowTrendingUpIcon : ArrowTrendingDownIcon;
});

const trendClasses = computed(() => {
    return props.trend === 'up' 
        ? 'text-emerald-600 bg-emerald-50' 
        : props.trend === 'down'
        ? 'text-red-600 bg-red-50'
        : 'text-slate-600 bg-slate-50';
});
</script>

<template>
    <div class="bg-white rounded-xl shadow-soft border border-slate-100 p-6 hover:shadow-lg transition-all duration-200">
        <div class="flex items-start justify-between">
            <div class="flex-1">
                <p class="text-sm font-medium text-slate-600 mb-1">{{ title }}</p>
                <div class="flex items-baseline gap-2">
                    <h3 class="text-3xl font-bold text-slate-900">{{ value }}</h3>
                    <span v-if="percentage" :class="['inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-semibold', trendClasses]">
                        <component :is="trendIcon" class="w-3 h-3" />
                        {{ percentage }}%
                    </span>
                </div>
                <p v-if="subtitle" class="text-xs text-slate-500 mt-1">{{ subtitle }}</p>
            </div>
            <div v-if="$slots.icon" :class="['p-3 rounded-lg', colorClasses.bg]">
                <div :class="['w-8 h-8', colorClasses.icon]">
                    <slot name="icon" />
                </div>
            </div>
        </div>

        <!-- Footer slot for additional information -->
        <div v-if="$slots.footer" class="mt-4 pt-4 border-t border-slate-100">
            <slot name="footer" />
        </div>
    </div>
</template>
