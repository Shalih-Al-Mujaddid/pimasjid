<script setup>
import { Bar } from 'vue-chartjs';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend
} from 'chart.js';

ChartJS.register(
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend
);

const props = defineProps({
    data: {
        type: Object,
        required: true,
        // Expected format:
        // {
        //   labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        //   income: [1000000, 1200000, ...],
        //   expense: [800000, 900000, ...]
        // }
    },
    height: {
        type: Number,
        default: 300
    },
    stacked: {
        type: Boolean,
        default: false
    }
});

const chartData = {
    labels: props.data.labels,
    datasets: [
        {
            label: 'Pemasukan',
            data: props.data.income,
            backgroundColor: '#10b981',
            borderColor: '#059669',
            borderWidth: 2,
            borderRadius: 6,
            borderSkipped: false,
        },
        {
            label: 'Pengeluaran',
            data: props.data.expense,
            backgroundColor: '#ef4444',
            borderColor: '#dc2626',
            borderWidth: 2,
            borderRadius: 6,
            borderSkipped: false,
        }
    ]
};

const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    interaction: {
        mode: 'index',
        intersect: false,
    },
    plugins: {
        legend: {
            display: true,
            position: 'top',
            labels: {
                usePointStyle: true,
                padding: 15,
                font: {
                    size: 12,
                    weight: 'bold'
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
                    let label = context.dataset.label || '';
                    if (label) {
                        label += ': ';
                    }
                    if (context.parsed.y !== null) {
                        label += new Intl.NumberFormat('id-ID', {
                            style: 'currency',
                            currency: 'IDR',
                            minimumFractionDigits: 0
                        }).format(context.parsed.y);
                    }
                    return label;
                }
            }
        }
    },
    scales: {
        y: {
            stacked: props.stacked,
            beginAtZero: true,
            ticks: {
                callback: function(value) {
                    return new Intl.NumberFormat('id-ID', {
                        notation: 'compact',
                        compactDisplay: 'short'
                    }).format(value);
                },
                font: {
                    size: 11
                }
            },
            grid: {
                color: 'rgba(0, 0, 0, 0.05)',
            }
        },
        x: {
            stacked: props.stacked,
            grid: {
                display: false
            },
            ticks: {
                font: {
                    size: 11
                }
            }
        }
    }
};
</script>

<template>
    <div class="w-full" :style="{ height: height + 'px' }">
        <Bar :data="chartData" :options="chartOptions" />
    </div>
</template>
