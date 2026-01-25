<script setup>
import { Line } from 'vue-chartjs';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend
} from 'chart.js';

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
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
        //   labels: ['Mon', 'Tue', 'Wed', ...],
        //   responseTime: [120, 145, 98, ...],
        //   memoryUsage: [45.5, 48.2, 42.1, ...],
        //   queryCount: [12, 15, 10, ...]
        // }
    },
    height: {
        type: Number,
        default: 280
    }
});

const chartData = {
    labels: props.data.labels,
    datasets: [
        {
            label: 'Response Time (ms)',
            data: props.data.responseTime,
            borderColor: '#3b82f6',
            backgroundColor: 'rgba(59, 130, 246, 0.1)',
            borderWidth: 2,
            tension: 0.4,
            yAxisID: 'y',
        },
        {
            label: 'Memory (MB)',
            data: props.data.memoryUsage,
            borderColor: '#8b5cf6',
            backgroundColor: 'rgba(139, 92, 246, 0.1)',
            borderWidth: 2,
            tension: 0.4,
            yAxisID: 'y1',
        },
        {
            label: 'DB Queries',
            data: props.data.queryCount,
            borderColor: '#f59e0b',
            backgroundColor: 'rgba(245, 158, 11, 0.1)',
            borderWidth: 2,
            tension: 0.4,
            yAxisID: 'y2',
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
                padding: 12,
                font: {
                    size: 11,
                    weight: 'bold'
                }
            }
        },
        tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 10,
            titleFont: {
                size: 12
            },
            bodyFont: {
                size: 11
            }
        }
    },
    scales: {
        y: {
            type: 'linear',
            display: true,
            position: 'left',
            title: {
                display: true,
                text: 'Response Time (ms)',
                font: {
                    size: 10
                }
            },
            ticks: {
                font: {
                    size: 10
                }
            },
            grid: {
                color: 'rgba(0, 0, 0, 0.05)',
            }
        },
        y1: {
            type: 'linear',
            display: true,
            position: 'right',
            title: {
                display: true,
                text: 'Memory (MB)',
                font: {
                    size: 10
                }
            },
            ticks: {
                font: {
                    size: 10
                }
            },
            grid: {
                drawOnChartArea: false,
            },
        },
        y2: {
            type: 'linear',
            display: false,
            position: 'right',
        },
        x: {
            grid: {
                display: false
            },
            ticks: {
                font: {
                    size: 10
                }
            }
        }
    }
};
</script>

<template>
    <div class="w-full" :style="{ height: height + 'px' }">
        <Line :data="chartData" :options="chartOptions" />
    </div>
</template>
