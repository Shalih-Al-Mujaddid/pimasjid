<script setup>
import { onMounted, ref, watch, nextTick, onUnmounted } from 'vue';
import Quill from 'quill';
import 'quill/dist/quill.snow.css';

const props = defineProps({
    modelValue: {
        type: String,
        default: '',
    },
    placeholder: {
        type: String,
        default: 'Tulis sesuatu di sini...',
    },
});

const emit = defineEmits(['update:modelValue']);

const editorRef = ref(null);
let quill = null;

const initQuill = () => {
    if (!editorRef.value) return;
    
    // Prevent double initialization
    if (quill) return;

    quill = new Quill(editorRef.value, {
        theme: 'snow',
        placeholder: props.placeholder,
        modules: {
            toolbar: [
                [{ header: [1, 2, 3, false] }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ list: 'ordered' }, { list: 'bullet' }],
                ['link', 'blockquote'],
                ['clean'],
            ],
        },
    });

    // Set initial content
    if (props.modelValue) {
        quill.root.innerHTML = props.modelValue;
    }

    // Update modelValue on change
    quill.on('text-change', () => {
        const html = quill.root.innerHTML;
        // Clean up empty paragraphs
        const cleanedHtml = html === '<p><br></p>' ? '' : html;
        if (cleanedHtml !== props.modelValue) {
            emit('update:modelValue', cleanedHtml);
        }
    });

    // Handle focus/blur styles if needed
    quill.on('selection-change', (range) => {
        if (range) {
            editorRef.value.parentElement.classList.add('editor-focused');
        } else {
            editorRef.value.parentElement.classList.remove('editor-focused');
        }
    });
};

onMounted(async () => {
    // Wait for two ticks to be absolutely sure Modal slot is rendered
    await nextTick();
    await nextTick();
    initQuill();
});

onUnmounted(() => {
    if (quill) {
        quill = null;
    }
});

// Watch for external changes to modelValue
watch(() => props.modelValue, (newValue) => {
    if (quill && newValue !== quill.root.innerHTML) {
        quill.root.innerHTML = newValue || '';
    }
});
</script>

<template>
    <div class="wysiwyg-wrapper transition-all duration-300">
        <div ref="editorRef" class="editor-container"></div>
    </div>
</template>

<style>
/* Customizing Quill styling to match the site's design */
.wysiwyg-wrapper {
    border: 1px solid #e2e8f0;
    border-radius: 1.5rem;
    overflow: hidden;
    background: #f8fafc;
}

.wysiwyg-wrapper.editor-focused {
    border-color: #10b981;
    box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
    background: white;
}

.ql-toolbar.ql-snow {
    border: none !important;
    border-bottom: 1px solid #e2e8f0 !important;
    background-color: #f8fafc;
    padding: 0.75rem 1rem !important;
}

.ql-container.ql-snow {
    border: none !important;
    font-size: 1rem;
    font-family: inherit;
}

.ql-editor {
    min-height: 250px;
    padding: 1.25rem 1.5rem !important;
    line-height: 1.6;
    color: #1e293b;
}

.ql-editor.ql-blank::before {
    font-style: italic;
    color: #94a3b8;
    left: 1.5rem !important;
}

/* Custom icon colors */
.ql-snow .ql-stroke {
    stroke: #64748b;
    stroke-width: 2;
}

.ql-snow .ql-fill {
    fill: #64748b;
}

.ql-snow.ql-toolbar button:hover .ql-stroke,
.ql-snow.ql-toolbar button.ql-active .ql-stroke {
    stroke: #10b981;
}

.ql-snow.ql-toolbar button:hover .ql-fill,
.ql-snow.ql-toolbar button.ql-active .ql-fill {
    fill: #10b981;
}

.ql-snow.ql-toolbar .ql-picker-label:hover .ql-stroke,
.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-stroke {
    stroke: #10b981;
}
</style>
