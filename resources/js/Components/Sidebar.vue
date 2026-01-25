<script setup>
import { computed } from 'vue';
import { Link, usePage } from '@inertiajs/vue3';

const page = usePage();
const user = computed(() => page.props.auth.user);
const pendingCount = computed(() => page.props.pendingApprovalsCount || 0);

// Role-based menu items
const menuItems = computed(() => {
    const role = user.value?.role;
    if (!role) return [];
    
    const items = [];

    
    // Dashboard - visible to ALL
    items.push({
        name: 'Dashboard',
        route: 'dashboard',
        icon: '🏠',
        visible: true,
    });
    
    // Approvals - ONLY ketua and super_admin
    if (['ketua', 'super_admin'].includes(role)) {
        items.push({
            name: 'Persetujuan',
            route: 'approvals.index',
            icon: '✅',
            badge: pendingCount.value,
            visible: true,
        });
    }
    
    // Keuangan - ONLY bendahara and super_admin
    if (['bendahara', 'super_admin'].includes(role)) {
        items.push({
            name: 'Keuangan',
            route: 'keuangan.index',
            icon: '💰',
            visible: true,
        });
        items.push({
            name: 'Input Transaksi',
            route: 'transactions.index',
            icon: '📝',
            visible: true,
        });
        items.push({
            name: 'Zakat',
            route: 'zakat.index',
            icon: '🕌',
            visible: true,
        });
        items.push({
            name: 'Qurban',
            route: 'qurban.index',
            icon: '🐑',
            visible: true,
        });
    }

    // Operasional - ONLY marbot and super_admin
    if (['marbot', 'super_admin'].includes(role)) {
        items.push({
            name: 'Jadwal Jumat',
            route: 'friday-schedules.index',
            icon: '🕌',
            visible: true,
        });
        items.push({
            name: 'Kelola Agenda',
            route: 'agendas.index',
            icon: '📅',
            visible: true,
        });
        items.push({
            name: 'Kelola Slide TV',
            route: 'slides.index',
            icon: '📺',
            visible: true,
        });
        items.push({
            name: 'Inventaris Aset',
            route: 'assets.index',
            icon: '🏛️',
            visible: true,
        });
        items.push({
            name: 'TV Display',
            route: 'display.index',
            icon: '📡',
            visible: true,
            external: true,
        });
    }

    // Posts - super_admin and ketua
    if (['super_admin', 'ketua'].includes(role)) {
        items.push({
            name: 'Berita & Kegiatan',
            route: 'posts.index',
            icon: '📰',
            visible: true,
        });
    }

    // Settings & Users - ONLY super_admin
    if (role === 'super_admin') {
         items.push({
            name: 'Pengaturan Web',
            route: 'settings.index',
            icon: '⚙️',
            visible: true,
        });
        items.push({
            name: 'User Management',
            route: 'users.index',
            icon: '👥',
            visible: true,
        });
        items.push({
            name: 'Component Showcase',
            route: 'components.showcase',
            icon: '🎨',
            visible: true,
        });

        items.push({
            name: 'Struktur Pengurus',
            route: 'committee-members.index',
            icon: '👥',
            visible: true,
        });
    }
    
    return items.filter(item => item.visible);
});
</script>

<template>
    <nav class="bg-white border-r border-slate-200 w-64 min-h-screen p-4">
        <!-- User Info -->
        <div class="mb-6 p-4 bg-gradient-islamic rounded-xl text-white">
            <div class="text-sm opacity-90">{{ user.role.replace('_', ' ').toUpperCase() }}</div>
            <div class="font-bold text-lg">{{ user.name }}</div>
            <div class="text-xs opacity-75">{{ user.email }}</div>
        </div>
        
        <!-- Menu Items -->
        <ul class="space-y-1">
            <li v-for="item in menuItems" :key="item.route">
                <Link
                    v-if="!item.external"
                    :href="route(item.route)"
                    :class="[
                        'flex items-center justify-between px-4 py-3 rounded-lg transition-colors',
                        route().current(item.route + '*')
                            ? 'bg-primary-100 text-primary-700 font-semibold'
                            : 'text-slate-700 hover:bg-slate-100'
                    ]"
                >
                    <div class="flex items-center gap-3">
                        <span class="text-xl">{{ item.icon }}</span>
                        <span>{{ item.name }}</span>
                    </div>
                    <span
                        v-if="item.badge && item.badge > 0"
                        class="inline-flex items-center justify-center w-6 h-6 text-xs font-bold text-white bg-red-500 rounded-full"
                    >
                        {{ item.badge }}
                    </span>
                </Link>
                
                <a
                    v-else
                    :href="route(item.route)"
                    target="_blank"
                    class="flex items-center gap-3 px-4 py-3 rounded-lg text-slate-700 hover:bg-slate-100 transition-colors"
                >
                    <span class="text-xl">{{ item.icon }}</span>
                    <span>{{ item.name }}</span>
                    <span class="text-xs text-slate-400">↗</span>
                </a>
            </li>
        </ul>
        
        <!-- Role Badge -->
        <div class="mt-8 p-3 bg-slate-50 rounded-lg border border-slate-200">
            <div class="text-xs text-slate-500 mb-1">Role Access</div>
            <div class="text-sm font-semibold text-slate-700">
                <span v-if="user.role === 'super_admin'">🔑 Full Access</span>
                <span v-else-if="user.role === 'ketua'">👔 Executive</span>
                <span v-else-if="user.role === 'bendahara'">💼 Finance</span>
                <span v-else-if="user.role === 'marbot'">🔧 Operations</span>
            </div>
        </div>
    </nav>
</template>
