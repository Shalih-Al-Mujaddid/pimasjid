<script setup>
import { Doughnut } from 'vue-chartjs';
import {
    Chart as ChartJS,
    ArcElement,
    Tooltip,
    Legend
} from 'chart.js';

ChartJS.register(ArcElement, Tooltip, Legend);

const props = defineProps({
    data: {
        type: Object,
        required: true,
        // Expected format:
        // {
        //   labels: ['Infaq', 'Donasi', 'Zakat', ...],
        //   amounts: [1000000, 500000, 2000000, ...]
        // }
    },
    type: {
        type: String,
        default: 'income',
        validator: (value) => ['income', 'expense'].includes(value)
    }
});

// Dynamic color palette
const colorPalettes = {
    income: [
        '#10b981', '#059669', '#34d399', '#6ee7b7', '#a7f3d0',
        '#14b8a6', '#0d9488', '#2dd4bf', '#5eead4', '#99f6e4'
    ],
    expense: [
        '#ef4444', '#dc2626', '#f87171', '#fca5a5', '#fecaca',
        '#f59e0b', '#d97706', '#fbbf24', '#fcd34d', '#fde68a'
    ]
};

const colors = colorPalettes[props.type];

const chartData = {
    labels: props.data.labels,
    datasets: [{
        data: props.data.amounts,
        backgroundColor: colors,
        borderColor: '#fff',
        borderWidth: 3,
        hoverOffset: 15
    }]
};

const totalAmount = props.data.amounts.reduce((sum, val) => sum + val, 0);

const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    cutout: '70%',
    plugins: {
        legend: {
            display: true,
            position: 'bottom',
            labels: {
                padding: 15,
                usePointStyle: true,
                font: {
                    size: 11,
                    weight: '600'
                },
                generateLabels: function(chart) {
                    const data = chart.data;
                    if (data.labels.length && data.datasets.length) {
                        return data.labels.map((label, i) => {
                            const value = data.datasets[0].data[i];
                            const percentage = ((value / totalAmount) * 100).toFixed(1);
                            return {
                                text: `${label} (${percentage}%)`,
                                fillStyle: data.datasets[0].backgroundColor[i],
                                hidden: false,
                                index: i
                            };
                        });
                    }
                    return [];
                }
            }
        },
        tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
                size: 13,
                weight: 'bold'
            },
            bodyFont: {
                size: 12
            },
            callbacks: {
                label: function(context) {
                    const label = context.label || '';
                    const value = context.parsed;
                    const percentage = ((value / totalAmount) * 100).toFixed(1);
                    const formatted = new Intl.NumberFormat('id-ID', {
                        style: 'currency',
                        currency: 'IDR',
                        minimumFractionDigits: 0
                    }).format(value);
                    return `${label}: ${formatted} (${percentage}%)`;
                }
            }
        }
    }
};
</script>

<template>
    <div class="relative w-full h-full flex items-center justify-center">
        <Doughnut :data="chartData" :options="chartOptions" />
        <!-- Center label -->
        <div class="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
            <p class="text-xs text-slate-400 uppercase font-bold">Total</p>
            <p class="text-lg font-bold" :class="type === 'income' ? 'text-emerald-600' : 'text-red-600'">
                {{ new Intl.NumberFormat('id-ID', {
                    style: 'currency',
                    currency: 'IDR',
                    notation: 'compact',
                    compactDisplay: 'short',
                    minimumFractionDigits: 0
                }).format(totalAmount) }}
            </p>
        </div>
    </div>
</template>
