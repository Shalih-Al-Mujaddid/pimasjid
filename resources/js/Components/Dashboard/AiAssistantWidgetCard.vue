<script setup>
import { ref } from 'vue';
import axios from 'axios';
import { 
    SparklesIcon, 
    PaperAirplaneIcon, 
    ArrowPathIcon,
    ChevronDownIcon,
    ChevronUpIcon,
    SpeakerWaveIcon,
    SpeakerXMarkIcon
} from '@heroicons/vue/24/outline';

const query = ref('');
const responseText = ref('');
const isLoading = ref(false);
const isSpeaking = ref(false);
const isExpanded = ref(false);

const quickPrompts = [
    { label: 'Kajian Terdekat', query: 'Apa kajian terdekat?' },
    { label: 'Saldo Kas', query: 'Berapa jumlah pemasukan dan pengeluaran masjid bulan ini?' },
    { label: 'Info Zakat', query: 'Bagaimana informasi zakat di masjid ini?' },
    { label: 'Pendaftaran TPA', query: 'Bagaimana cara pendaftaran TPA santri baru?' }
];

const askAi = async (promptText = null) => {
    const text = promptText || query.value.trim();
    if (!text || isLoading.value) return;

    if (!promptText) {
        query.value = '';
    }

    isLoading.value = true;
    isExpanded.value = true;
    responseText.value = '';

    try {
        const res = await axios.post('/api/ai-assistant/chat', {
            message: text,
            history: []
        });

        if (res.data && res.data.reply) {
            responseText.value = res.data.reply;
        } else {
            responseText.value = 'Mohon maaf, sistem AI Assistant tidak memberikan respon.';
        }
    } catch (err) {
        console.error('AI Assistant Error:', err);
        responseText.value = 'Mohon maaf, terjadi kendala koneksi pada sistem AI Assistant.';
    } finally {
        isLoading.value = false;
    }
};

const formatMarkdown = (text) => {
    if (!text) return '';
    return text
        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
        .replace(/\*(.*?)\*/g, '<em>$1</em>')
        .replace(/`([^`]+)`/g, '<code class="bg-emerald-100 text-emerald-900 px-1 py-0.5 rounded text-xs">$1</code>')
        .replace(/\n/g, '<br/>');
};

const toggleSpeech = () => {
    if (!('speechSynthesis' in window)) return;
    if (isSpeaking.value) {
        window.speechSynthesis.cancel();
        isSpeaking.value = false;
        return;
    }

    const cleanText = responseText.value.replace(/[*_`#]/g, '').replace(/<[^>]*>/g, '');
    const utterance = new SpeechSynthesisUtterance(cleanText);
    utterance.lang = 'id-ID';
    utterance.onend = () => { isSpeaking.value = false; };
    utterance.onerror = () => { isSpeaking.value = false; };
    isSpeaking.value = true;
    window.speechSynthesis.speak(utterance);
};
</script>

<template>
    <!-- Compact Minimal Icon Trigger Bar -->
    <div class="bg-gradient-to-r from-emerald-900 via-emerald-800 to-teal-900 rounded-2xl shadow-md border border-emerald-700/60 p-2.5 sm:p-3 text-white transition-all duration-300">
        <div class="flex items-center justify-between gap-3">
            <!-- Compact Left Icon & Title Badge -->
            <div class="flex items-center gap-2.5 shrink-0">
                <div class="w-8 h-8 rounded-xl bg-gradient-to-tr from-amber-400 to-amber-500 flex items-center justify-center shadow-inner text-emerald-950">
                    <SparklesIcon class="w-5 h-5 text-emerald-950 animate-pulse" />
                </div>
                <div class="hidden xs:block sm:block">
                    <div class="flex items-center gap-1.5">
                        <span class="font-bold text-xs sm:text-sm text-white tracking-wide">Huda — Asisten Masjid</span>
                        <span class="w-1.5 h-1.5 rounded-full bg-amber-400 animate-ping"></span>
                    </div>
                </div>
            </div>

            <!-- Compact Inline Search/Ask Input -->
            <form @submit.prevent="askAi()" class="flex-1 flex items-center gap-1.5 max-w-xl">
                <input 
                    v-model="query"
                    type="text" 
                    placeholder="Tanya seputar kajian, kas, sholat..." 
                    class="w-full bg-emerald-950/70 border border-emerald-600/50 focus:border-amber-400 focus:ring-1 focus:ring-amber-400/40 rounded-xl px-3 py-1.5 text-xs sm:text-sm text-white placeholder-emerald-300/60 transition shadow-inner"
                    :disabled="isLoading"
                />
                
                <button 
                    type="submit"
                    :disabled="!query.trim() || isLoading"
                    class="bg-amber-400 hover:bg-amber-300 text-emerald-950 font-bold p-2 rounded-xl transition shadow-sm flex items-center justify-center shrink-0 disabled:opacity-40"
                    title="Tanya AI"
                >
                    <PaperAirplaneIcon class="w-4 h-4 -rotate-45" />
                </button>
            </form>

            <!-- Toggle Expand Answer Button if has answer -->
            <button 
                v-if="responseText"
                @click="isExpanded = !isExpanded"
                class="text-xs text-emerald-200 hover:text-white p-1.5 rounded-lg bg-emerald-800/40 hover:bg-emerald-700/50 transition flex items-center gap-1 shrink-0"
            >
                <component :is="isExpanded ? ChevronUpIcon : ChevronDownIcon" class="w-4 h-4 text-amber-400" />
            </button>
        </div>

        <!-- Quick Chips Bar (Compact 1-line) -->
        <div class="mt-2 pt-2 border-t border-emerald-700/40 flex items-center gap-1.5 overflow-x-auto no-scrollbar">
            <span class="text-[10px] text-emerald-300/70 shrink-0 font-medium">Quick:</span>
            <button
                v-for="(p, i) in quickPrompts"
                :key="i"
                @click="askAi(p.query)"
                :disabled="isLoading"
                class="shrink-0 text-[11px] bg-emerald-800/40 hover:bg-emerald-700/60 text-emerald-100 border border-emerald-600/30 hover:border-amber-400/50 px-2.5 py-0.5 rounded-md transition disabled:opacity-50"
            >
                {{ p.label }}
            </button>
        </div>

        <!-- Answer Box (Only visible when user asks or toggles expand) -->
        <div v-if="isExpanded" class="mt-3 pt-3 border-t border-emerald-700/60">
            <div class="bg-emerald-950/80 rounded-xl p-3.5 border border-emerald-700/50 relative">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-xs font-bold text-amber-300 flex items-center gap-1.5">
                        <SparklesIcon class="w-4 h-4 text-amber-400" />
                        Jawaban AI:
                    </span>
                    <button 
                        v-if="responseText && !isLoading"
                        @click="toggleSpeech"
                        class="text-[11px] text-emerald-300 hover:text-white flex items-center gap-1 transition bg-emerald-800/60 px-2 py-0.5 rounded-md"
                    >
                        <SpeakerWaveIcon v-if="!isSpeaking" class="w-3.5 h-3.5 text-amber-400" />
                        <SpeakerXMarkIcon v-else class="w-3.5 h-3.5 text-amber-400 animate-pulse" />
                        <span>{{ isSpeaking ? 'Stop' : 'Dengarkan' }}</span>
                    </button>
                </div>

                <!-- Loading state -->
                <div v-if="isLoading" class="flex items-center gap-2 py-2 text-emerald-200 text-xs">
                    <ArrowPathIcon class="w-4 h-4 animate-spin text-amber-400" />
                    <span>Huda sedang mengambil data dari database masjid...</span>
                </div>

                <!-- Content -->
                <div v-else class="text-xs sm:text-sm text-emerald-50 leading-relaxed prose prose-invert max-w-none">
                    <div v-html="formatMarkdown(responseText)"></div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
    display: none;
}
.no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>
