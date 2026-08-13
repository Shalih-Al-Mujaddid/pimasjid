<script setup>
import { ref } from 'vue';
import Navbar from '@/Components/Public/Navbar.vue';
import MobileBottomNav from '@/Components/Landing/MobileBottomNav.vue';
import MobileMenuDrawer from '@/Components/Landing/MobileMenuDrawer.vue';
import AiAssistantModal from '@/Components/AiAssistantModal.vue';

const props = defineProps({
    transparentNav: {
        type: Boolean,
        default: true
    }
});

// State management
const showMobileMenu = ref(false);
const navbarRef = ref(null);

// Methods
const openDonationModal = () => {
    if (navbarRef.value) {
        navbarRef.value.openDonationModal();
    }
};

const openMobileMenu = () => {
    showMobileMenu.value = true;
};

const closeMobileMenu = () => {
    showMobileMenu.value = false;
};

// Expose methods for child components to call
defineExpose({
    openDonationModal
});
</script>

<template>
    <div class="min-h-screen bg-slate-50">
        <!-- Top Navbar -->
        <Navbar 
            ref="navbarRef"
            :transparent-on-top="transparentNav"
        />

        <!-- Main Content Slot -->
        <main>
            <slot />
        </main>

        <!-- Mobile Bottom Navigation (Mobile/Tablet Only) -->
        <MobileBottomNav 
            @openDonation="openDonationModal"
            @openMenu="openMobileMenu"
        />

        <!-- Mobile Menu Drawer -->
        <MobileMenuDrawer 
            :open="showMobileMenu"
            @close="closeMobileMenu"
        />

        <!-- AI Assistant Floating Modal -->
        <AiAssistantModal />
    </div>
</template>
