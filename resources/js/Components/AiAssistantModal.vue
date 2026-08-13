<script setup>
import { ref, nextTick, watch, onMounted } from 'vue';
import axios from 'axios';
import { 
    SparklesIcon, 
    XMarkIcon, 
    PaperAirplaneIcon, 
    ArrowPathIcon,
    SpeakerWaveIcon,
    SpeakerXMarkIcon,
    ChatBubbleLeftRightIcon,
    QuestionMarkCircleIcon,
    BanknotesIcon,
    ClockIcon,
    CalendarDaysIcon,
    BookOpenIcon,
    ShieldCheckIcon
} from '@heroicons/vue/24/outline';

const isOpen = ref(false);
const inputMessage = ref('');
const isLoading = ref(false);
const messagesRef = ref(null);
const isSpeaking = ref(false);

const messages = ref([
    {
        role: 'assistant',
        content: "Assalamu'alaikum Warahmatullahi Wabarakatuh! 🌿\n\nSaya adalah **Huda — Asisten Masjid**. Ada yang bisa saya bantu terkait jadwal sholat, saldo kas, agenda kajian, zakat, qurban, atau info masjid?",
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    }
]);

const suggestions = [
    { label: 'Kajian Terdekat', icon: CalendarDaysIcon, query: 'Apa kajian terdekat?' },
    { label: 'Ustaz Pengisi Kajian', icon: BookOpenIcon, query: 'Siapa ustaz yang mengisi kajian minggu ini?' },
    { label: 'Kegiatan Masjid', icon: CalendarDaysIcon, query: 'Apa kegiatan masjid minggu ini?' },
    { label: 'Informasi Zakat', icon: BanknotesIcon, query: 'Bagaimana informasi zakat di masjid ini?' },
    { label: 'Saldo Kas Masjid', icon: BanknotesIcon, query: 'Berapa jumlah pemasukan masjid bulan ini?' }
];

const toggleModal = () => {
    isOpen.value = !isOpen.value;
    if (isOpen.value) {
        scrollToBottom();
    }
};

const scrollToBottom = async () => {
    await nextTick();
    if (messagesRef.value) {
        messagesRef.value.scrollTop = messagesRef.value.scrollHeight;
    }
};

const formatMarkdown = (text) => {
    if (!text) return '';
    let formatted = text
        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
        .replace(/\*(.*?)\*/g, '<em>$1</em>')
        .replace(/`([^`]+)`/g, '<code class="bg-emerald-100 text-emerald-900 px-1.5 py-0.5 rounded font-mono text-xs">$1</code>')
        .replace(/\n/g, '<br/>');
    return formatted;
};

const sendMessage = async (textToSend = null) => {
    const text = textToSend || inputMessage.value.trim();
    if (!text || isLoading.value) return;

    // Push User Message
    messages.value.push({
        role: 'user',
        content: text,
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    });

    if (!textToSend) {
        inputMessage.value = '';
    }

    isLoading.value = true;
    scrollToBottom();

    try {
        const historyForApi = messages.value.slice(-6).map(m => ({
            role: m.role,
            content: m.content
        }));

        const response = await axios.post('/api/ai-assistant/chat', {
            message: text,
            history: historyForApi
        });

        if (response.data && response.data.reply) {
            messages.value.push({
                role: 'assistant',
                content: response.data.reply,
                time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
            });
        } else {
            messages.value.push({
                role: 'assistant',
                content: 'Mohon maaf, terjadi gangguan jaringan. Silakan coba lagi sebentar lagi.',
                time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
            });
        }
    } catch (error) {
        console.error('AI Chat Error:', error);
        messages.value.push({
            role: 'assistant',
            content: 'Mohon maaf, sistem AI Assistant sedang sibuk. Silakan coba beberapa saat lagi.',
            time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        });
    } finally {
        isLoading.value = false;
        scrollToBottom();
    }
};

const resetChat = () => {
    stopSpeech();
    messages.value = [
        {
            role: 'assistant',
            content: "Assalamu'alaikum! Chat telah direset. Ada informasi masjid yang ingin Anda tanyakan?",
            time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        }
    ];
};

const speakText = (text) => {
    if (!('speechSynthesis' in window)) return;
    
    if (isSpeaking.value) {
        stopSpeech();
        return;
    }

    const cleanText = text.replace(/[*_`#]/g, '').replace(/<[^>]*>/g, '');
    const utterance = new SpeechSynthesisUtterance(cleanText);
    utterance.lang = 'id-ID';
    utterance.rate = 1.0;

    utterance.onend = () => {
        isSpeaking.value = false;
    };

    utterance.onerror = () => {
        isSpeaking.value = false;
    };

    isSpeaking.value = true;
    window.speechSynthesis.speak(utterance);
};

const stopSpeech = () => {
    if ('speechSynthesis' in window) {
        window.speechSynthesis.cancel();
    }
    isSpeaking.value = false;
};
</script>

<template>
    <!-- Floating Trigger Button -->
    <div class="fixed bottom-20 md:bottom-6 right-5 z-50">
        <button 
            @click="toggleModal"
            class="group relative flex items-center gap-2.5 px-4 py-3 bg-gradient-to-r from-emerald-600 to-teal-700 hover:from-emerald-500 hover:to-teal-600 text-white rounded-full shadow-xl shadow-emerald-900/30 transition-all duration-300 transform hover:scale-105 active:scale-95 border border-emerald-400/40"
            aria-label="Tanya AI Assistant Masjid"
        >
            <span class="relative flex h-3 w-3">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                <span class="relative inline-flex rounded-full h-3 w-3 bg-amber-400"></span>
            </span>

            <SparklesIcon class="w-6 h-6 text-amber-300 animate-pulse" />
            
            <span class="font-semibold text-sm tracking-wide hidden sm:inline-block">Tanya Huda AI Masjid</span>

            <!-- Badge notification -->
            <span class="absolute -top-1 -right-1 bg-amber-500 text-emerald-950 font-extrabold text-[10px] px-1.5 py-0.5 rounded-full uppercase tracking-wider border border-white">
                AI
            </span>
        </button>
    </div>

    <!-- Mobile Backdrop Overlay -->
    <div 
        v-if="isOpen" 
        @click="toggleModal"
        class="fixed inset-0 bg-black/40 backdrop-blur-xs z-40 sm:hidden transition-opacity"
    ></div>

    <!-- Chat Modal Window -->
    <Transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="opacity-0 translate-y-8 scale-95"
        enter-to-class="opacity-100 translate-y-0 scale-100"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="opacity-100 translate-y-0 scale-100"
        leave-to-class="opacity-0 translate-y-8 scale-95"
    >
        <div 
            v-if="isOpen"
            class="fixed inset-x-2 bottom-2 sm:inset-auto sm:bottom-6 sm:right-6 z-50 w-auto sm:w-[440px] h-[calc(100vh-1rem)] sm:h-[600px] max-h-[92vh] sm:max-h-[85vh] bg-white rounded-2xl shadow-2xl border border-emerald-100 flex flex-col overflow-hidden transition-all duration-300"
        >
            <!-- Header -->
            <div class="bg-gradient-to-r from-emerald-800 via-emerald-700 to-teal-800 p-3.5 sm:p-4 text-white flex items-center justify-between shadow-md relative shrink-0">
                <div class="flex items-center gap-3">
                    <div class="relative w-10 h-10 rounded-full bg-emerald-900/60 border border-amber-400/50 flex items-center justify-center shadow-inner">
                        <SparklesIcon class="w-6 h-6 text-amber-300" />
                        <span class="absolute bottom-0 right-0 w-2.5 h-2.5 bg-emerald-400 rounded-full ring-2 ring-emerald-800"></span>
                    </div>
                    <div>
                        <h3 class="font-bold text-base tracking-wide flex items-center gap-1.5">
                            Huda AI Masjid
                            <span class="bg-amber-400/20 text-amber-300 text-[10px] px-2 py-0.5 rounded-full border border-amber-400/30 font-medium">Smart AI</span>
                        </h3>
                        <p class="text-xs text-emerald-200 flex items-center gap-1">
                            <ShieldCheckIcon class="w-3.5 h-3.5 text-amber-400" />
                            Jawaban Real-Time Data Masjid
                        </p>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex items-center gap-1">
                    <button 
                        @click="resetChat" 
                        class="p-1.5 hover:bg-emerald-600/60 rounded-lg text-emerald-200 hover:text-white transition"
                        title="Reset Percakapan"
                    >
                        <ArrowPathIcon class="w-4 h-4" />
                    </button>
                    <button 
                        @click="toggleModal" 
                        class="p-1.5 hover:bg-emerald-600/60 rounded-lg text-emerald-200 hover:text-white transition"
                        title="Tutup Modal"
                    >
                        <XMarkIcon class="w-5 h-5" />
                    </button>
                </div>
            </div>

            <!-- Messages Area -->
            <div ref="messagesRef" class="flex-1 p-4 overflow-y-auto bg-slate-50 space-y-4">
                <div 
                    v-for="(msg, index) in messages" 
                    :key="index"
                    :class="[
                        'flex flex-col max-w-[85%]',
                        msg.role === 'user' ? 'ml-auto items-end' : 'mr-auto items-start'
                    ]"
                >
                    <!-- Role label -->
                    <span class="text-[10px] text-slate-400 mb-1 px-1">
                        {{ msg.role === 'user' ? 'Anda' : 'Asisten AI' }} • {{ msg.time }}
                    </span>

                    <div 
                        :class="[
                            'p-3.5 rounded-2xl text-sm leading-relaxed shadow-sm relative group',
                            msg.role === 'user' 
                                ? 'bg-gradient-to-r from-emerald-600 to-teal-700 text-white rounded-br-none' 
                                : 'bg-white text-slate-800 border border-slate-200/80 rounded-bl-none'
                        ]"
                    >
                        <!-- Formatted Content -->
                        <div v-html="formatMarkdown(msg.content)" class="prose prose-sm max-w-none"></div>

                        <!-- Voice Speaker Button for AI Messages -->
                        <button 
                            v-if="msg.role === 'assistant'"
                            @click="speakText(msg.content)"
                            class="mt-2 text-xs flex items-center gap-1 text-emerald-600 hover:text-emerald-800 font-medium transition"
                            title="Dengarkan Suara"
                        >
                            <SpeakerWaveIcon v-if="!isSpeaking" class="w-3.5 h-3.5" />
                            <SpeakerXMarkIcon v-else class="w-3.5 h-3.5 text-amber-600 animate-pulse" />
                            <span>{{ isSpeaking ? 'Hentikan Audio' : 'Baca Suara' }}</span>
                        </button>
                    </div>
                </div>

                <!-- Typing indicator -->
                <div v-if="isLoading" class="flex items-start gap-2 mr-auto">
                    <div class="bg-white border border-slate-200 p-3 rounded-2xl rounded-bl-none shadow-sm flex items-center gap-1.5">
                        <span class="w-2 h-2 bg-emerald-500 rounded-full animate-bounce"></span>
                        <span class="w-2 h-2 bg-emerald-500 rounded-full animate-bounce [animation-delay:0.2s]"></span>
                        <span class="w-2 h-2 bg-emerald-500 rounded-full animate-bounce [animation-delay:0.4s]"></span>
                        <span class="text-xs text-slate-400 font-medium ml-1">AI sedang memproses...</span>
                    </div>
                </div>
            </div>

            <!-- Quick Suggestion Chips -->
            <div class="px-3 py-2 bg-slate-100 border-t border-slate-200/60 flex items-center gap-1.5 overflow-x-auto no-scrollbar">
                <button
                    v-for="(sug, idx) in suggestions"
                    :key="idx"
                    @click="sendMessage(sug.query)"
                    :disabled="isLoading"
                    class="flex-shrink-0 flex items-center gap-1 text-[11px] font-medium bg-white hover:bg-emerald-50 text-slate-700 hover:text-emerald-700 border border-slate-200 hover:border-emerald-300 px-2.5 py-1 rounded-full transition shadow-2xs disabled:opacity-50 whitespace-nowrap"
                >
                    <component :is="sug.icon" class="w-3 h-3 text-emerald-600" />
                    {{ sug.label }}
                </button>
            </div>

            <!-- Input Bar -->
            <form @submit.prevent="sendMessage()" class="p-3 bg-white border-t border-slate-200 flex items-center gap-2">
                <input 
                    v-model="inputMessage"
                    type="text"
                    placeholder="Tanya seputar masjid, sholat, kas..."
                    class="flex-1 bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition"
                    :disabled="isLoading"
                />
                
                <button 
                    type="submit"
                    :disabled="!inputMessage.trim() || isLoading"
                    class="p-2.5 bg-emerald-600 hover:bg-emerald-700 disabled:bg-slate-300 text-white rounded-xl transition shadow-md flex items-center justify-center disabled:cursor-not-allowed"
                >
                    <PaperAirplaneIcon class="w-5 h-5 -rotate-45" />
                </button>
            </form>
        </div>
    </Transition>
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
