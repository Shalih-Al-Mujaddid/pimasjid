<script setup>
import { ref, onMounted } from 'vue';
import { Head } from '@inertiajs/vue3';
import axios from 'axios';

const slides = ref([]);
const posts = ref([]);
const currentSlide = ref(0);
const slideInterval = ref(null);

const props = defineProps({
    settings: Object,
});

// Auto-play slides
const startSlideShow = () => {
    slideInterval.value = setInterval(() => {
        currentSlide.value = (currentSlide.value + 1) % slides.value.length;
    }, 5000);
};

// Fetch slides
const fetchSlides = async () => {
    try {
        const response = await axios.get('/api/slides');
        slides.value = response.data;
        if (slides.value.length > 0) {
            startSlideShow();
        }
    } catch (error) {
        console.error('Error fetching slides:', error);
    }
};

// Fetch latest post
const fetchPosts = async () => {
    try {
        const response = await axios.get('/api/posts/latest');
        posts.value = response.data;
    } catch (error) {
        console.error('Error fetching posts:', error);
    }
};

onMounted(() => {
    fetchSlides();
    fetchPosts();
});
</script>

<template>
    <Head title="Display" />
    
    <div class="display-container">
        <!-- Slide Show -->
        <div class="slide-show" v-if="slides.length > 0">
            <img 
                v-for="(slide, index) in slides" 
                :key="slide.id"
                :src="slide.image_url"
                :alt="slide.title"
                v-show="index === currentSlide"
                class="slide-image"
            />
        </div>

        <!-- Latest News -->
        <div class="latest-news" v-if="posts.length > 0">
            <div class="news-ticker">
                <span class="news-label">Berita Terkini</span>
                <span class="news-text">{{ posts[0].title }}</span>
            </div>
        </div>

        <!-- Clock -->
        <div class="clock-display">
            <div class="time" id="clock"></div>
            <div class="date" id="date"></div>
        </div>
    </div>
</template>

<style scoped>
.display-container {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    position: relative;
    background: #000;
}

.slide-show {
    width: 100%;
    height: 100%;
}

.slide-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.latest-news {
    position: absolute;
    bottom: 100px;
    left: 0;
    right: 0;
    padding: 15px;
    background: rgba(0,0,0,0.7);
    color: white;
}

.news-ticker {
    display: flex;
    align-items: center;
    gap: 10px;
}

.news-label {
    background: #e18f3a;
    padding: 5px 10px;
    border-radius: 4px;
    font-weight: bold;
}

.clock-display {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    text-align: center;
    color: white;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

.time {
    font-size: 120px;
    font-weight: bold;
}

.date {
    font-size: 40px;
}
</style>
