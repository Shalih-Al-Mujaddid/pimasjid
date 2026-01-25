<script setup>
import Checkbox from '@/Components/Checkbox.vue';
import AuthLayout from '@/Layouts/AuthLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';

defineProps({
    canResetPassword: {
        type: Boolean,
    },
    status: {
        type: String,
    },
});

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
    <AuthLayout>
        <Head title="Masuk Akun" />

        <div class="mb-8 text-center">
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white font-arabic">Bismillah</h1>
            <p class="text-sm text-gray-600 dark:text-gray-400 mt-2">
                Silahkan masuk untuk melanjutkan
            </p>
        </div>

        <div v-if="status" class="mb-4 text-sm font-medium text-green-600 dark:text-green-400 bg-green-50 p-3 rounded-md border border-green-200">
            {{ status }}
        </div>

        <form @submit.prevent="submit" class="space-y-6">
            <div>
                <InputLabel for="email" value="Email" class="sr-only" />
                <div class="relative">
                    <TextInput
                        id="email"
                        type="email"
                        class="mt-1 block w-full pl-3 pr-10 py-3 border-gray-300 focus:border-primary-500 focus:ring-primary-500 rounded-lg shadow-sm"
                        v-model="form.email"
                        required
                        autofocus
                        autocomplete="username"
                        placeholder="Email Address"
                    />
                    <!-- Icon placeholder could go here -->
                </div>
                <InputError class="mt-2" :message="form.errors.email" />
            </div>

            <div>
                 <InputLabel for="password" value="Password" class="sr-only" />
                 <div class="relative">
                    <TextInput
                        id="password"
                        type="password"
                        class="mt-1 block w-full pl-3 pr-10 py-3 border-gray-300 focus:border-primary-500 focus:ring-primary-500 rounded-lg shadow-sm"
                        v-model="form.password"
                        required
                        autocomplete="current-password"
                        placeholder="Password"
                    />
                </div>
                <InputError class="mt-2" :message="form.errors.password" />
            </div>

            <div class="flex items-center justify-between">
                <label class="flex items-center">
                    <Checkbox name="remember" v-model:checked="form.remember" class="text-primary-600 focus:ring-primary-500" />
                    <span class="ms-2 text-sm text-gray-600 dark:text-gray-400">Ingat Saya</span>
                </label>

                <Link
                    v-if="canResetPassword"
                    :href="route('password.request')"
                    class="text-sm text-primary-600 hover:text-primary-800 font-medium hover:underline focus:outline-none"
                >
                    Lupa Password?
                </Link>
            </div>

            <div class="pt-2">
                <PrimaryButton
                    class="w-full justify-center py-3 bg-primary-600 hover:bg-primary-700 text-white shadow-islamic transition-all duration-300 transform hover:-translate-y-1"
                    :class="{ 'opacity-70 cursor-not-allowed': form.processing }"
                    :disabled="form.processing"
                >
                    <span v-if="!form.processing">Masuk Sekarang</span>
                    <span v-else>Memproses...</span>
                </PrimaryButton>
            </div>
        </form>
    </AuthLayout>
</template>
