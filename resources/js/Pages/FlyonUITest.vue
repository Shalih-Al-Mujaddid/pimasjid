<script setup>
import { Head } from '@inertiajs/vue3';
</script>

<template>
    <Head title="FlyonUI Test" />

    <div class="p-8 space-y-8 bg-gray-50 min-h-screen">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">FlyonUI Test Page</h1>

        <!-- Buttons Section -->
        <section class="bg-white p-6 rounded-xl shadow-soft">
            <h2 class="text-xl font-semibold mb-4">Buttons</h2>
            <div class="flex flex-wrap gap-4">
                <button class="btn btn-primary">Primary Button</button>
                <button class="btn btn-secondary">Secondary Button</button>
                <button class="btn btn-outline btn-primary">Outline Primary</button>
                <button class="btn btn-success">Success</button>
                <button class="btn btn-error">Error</button>
            </div>
        </section>

        <!-- Accordion Section (Interactive) -->
        <section class="bg-white p-6 rounded-xl shadow-soft">
            <h2 class="text-xl font-semibold mb-4">Accordion (Interactive)</h2>
            <div class="accordion accordion-border accordion-flush" id="accordion-example">
                <div class="accordion-item" id="item-1">
                    <button class="accordion-header" type="button" data-flyon-target="#collapse-1" aria-expanded="true" aria-controls="collapse-1">
                        What is FlyonUI?
                        <span class="accordion-icon"></span>
                    </button>
                    <div id="collapse-1" class="accordion-collapse collapse show" aria-labelledby="item-1" data-flyon-parent="#accordion-example">
                        <div class="accordion-body">
                            FlyonUI is an open-source Tailwind CSS component library with interactive elements.
                        </div>
                    </div>
                </div>
                <div class="accordion-item" id="item-2">
                    <button class="accordion-header collapsed" type="button" data-flyon-target="#collapse-2" aria-expanded="false" aria-controls="collapse-2">
                        Is it interactive?
                        <span class="accordion-icon"></span>
                    </button>
                    <div id="collapse-2" class="accordion-collapse collapse" aria-labelledby="item-2" data-flyon-parent="#accordion-example">
                        <div class="accordion-body">
                            Yes, it comes with JavaScript for interactive components like this accordion, modals, and dropdowns.
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Card Section -->
        <section class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div class="card bg-white shadow-soft">
                <div class="card-body">
                    <h2 class="card-title text-primary-600">FlyonUI Card</h2>
                    <p>This is a standard card component from FlyonUI using our custom primary color.</p>
                    <div class="card-actions justify-end">
                        <button class="btn btn-primary">Action</button>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>
