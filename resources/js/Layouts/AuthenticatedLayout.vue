<script setup>
import { ref } from 'vue';
import { useForm } from '@inertiajs/vue3';
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
import Dropdown from '@/Components/Dropdown.vue';
import DropdownLink from '@/Components/DropdownLink.vue';
import Sidebar from '@/Components/Sidebar.vue';
import AiAssistantModal from '@/Components/AiAssistantModal.vue';
import { Link } from '@inertiajs/vue3';
import { Bars3Icon, XMarkIcon } from '@heroicons/vue/24/outline';

const showingSidebar = ref(false);

const stopImpersonation = () => {
    useForm({}).post(route('users.stopImpersonation'));
};
</script>

<template>
    <div class="h-screen flex overflow-hidden bg-slate-50 dark:bg-slate-900 relative">
        <!-- Mobile Sidebar Overlay -->
        <div 
            v-if="showingSidebar" 
            class="fixed inset-0 bg-black/50 z-40 lg:hidden backdrop-blur-sm"
            @click="showingSidebar = false"
        ></div>

        <!-- Sidebar (Fixed) -->
        <aside 
            class="fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-slate-200 transform transition-transform duration-300 lg:translate-x-0 overflow-y-auto"
            :class="showingSidebar ? 'translate-x-0 shadow-2xl' : '-translate-x-full'"
        >
            <div class="h-full flex flex-col">
                <!-- Mobile Close Button -->
                <div class="lg:hidden p-4 flex justify-end">
                    <button @click="showingSidebar = false" class="p-2 text-slate-500 hover:text-slate-700">
                        <XMarkIcon class="w-6 h-6" />
                    </button>
                </div>

                <Sidebar />
            </div>
        </aside>

        <!-- Main Content Wrapper -->
        <div class="flex-1 flex flex-col min-w-0 lg:ml-64 relative overflow-hidden">
            
            <!-- Top Header (Hamburger + User Dropdown) -->
            <header class="bg-white border-b border-slate-200 h-16 flex items-center justify-between px-4 lg:px-8 shadow-sm z-30">
                <!-- Left: Hamburger (Mobile Only) -->
                <div class="flex items-center gap-4">
                    <button 
                        @click="showingSidebar = true" 
                        class="p-2 text-slate-500 hover:bg-slate-100 rounded-lg lg:hidden"
                    >
                        <Bars3Icon class="w-6 h-6" />
                    </button>
                    <!-- Small Logo for Mobile Header -->
                    <Link :href="route('dashboard')" class="lg:hidden">
                        <ApplicationLogo class="block h-8 w-auto fill-current text-emerald-600" />
                    </Link>
                </div>

                <!-- Right: User Dropdown -->
                <div class="flex items-center">
                    <div class="relative ms-3">
                        <Dropdown align="right" width="48">
                            <template #trigger>
                                <span class="inline-flex rounded-md">
                                    <button
                                        type="button"
                                        class="inline-flex items-center gap-2 rounded-md border border-transparent bg-white px-3 py-2 text-sm font-medium leading-4 text-slate-700 transition duration-150 ease-in-out hover:text-slate-900 focus:outline-none"
                                    >
                                        {{ $page.props.auth.user.name }}

                                        <svg
                                            class="-me-0.5 ms-2 h-4 w-4"
                                            xmlns="http://www.w3.org/2000/svg"
                                            viewBox="0 0 20 20"
                                            fill="currentColor"
                                        >
                                            <path
                                                fill-rule="evenodd"
                                                d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                                clip-rule="evenodd"
                                            />
                                        </svg>
                                    </button>
                                </span>
                            </template>

                            <template #content>
                                <DropdownLink :href="route('profile.edit')">
                                    Profile
                                </DropdownLink>
                                <DropdownLink :href="route('logout')" method="post" as="button">
                                    Log Out
                                </DropdownLink>
                            </template>
                        </Dropdown>
                    </div>
                </div>
            </header>

            <!-- Impersonation Banner (Global) -->
            <div v-if="$page.props.isImpersonating" class="bg-amber-500 text-white px-4 lg:px-8 py-3 flex items-center justify-between shadow-md z-20">
                <div class="flex items-center gap-3">
                    <span class="text-2xl">⚠️</span>
                    <div>
                        <h3 class="font-semibold text-sm">Mode Impersonation Aktif</h3>
                        <p class="text-[10px] text-amber-100 uppercase tracking-wider">Login sebagai: <strong>{{ $page.props.auth.user.name }}</strong></p>
                    </div>
                </div>
                <button 
                    @click="stopImpersonation"
                    class="bg-white text-amber-600 hover:bg-amber-50 font-bold py-1.5 px-3 rounded-lg transition-colors text-xs shadow-sm uppercase"
                >
                    Kembali
                </button>
            </div>

            <!-- Main Content Scroll Area -->
            <main class="flex-1 overflow-x-hidden overflow-y-auto bg-slate-50 dark:bg-slate-900 scroll-smooth">
                <!-- Page Heading (Optional) -->
                <div v-if="$slots.header" class="bg-white shadow-sm border-b border-slate-100 dark:bg-slate-800 dark:border-slate-700">
                    <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                        <slot name="header" />
                    </div>
                </div>

                <!-- Content Slot -->
                <div class="py-12 px-4 sm:px-6 lg:px-8">
                    <slot />
                </div>
            </main>

            <!-- AI Assistant Floating Modal -->
            <AiAssistantModal />
        </div>
    </div>
</template>
