# --- Tahap 1: Build Frontend (Vue.js + Tailwind) ---
FROM node:20-alpine AS frontend-builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# --- Tahap 2: Build Backend (Laravel) ---
FROM php:8.2-fpm-alpine
WORKDIR /var/www/html

# Instal ekstensi PHP yang dibutuhkan Laravel & Nginx
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    oniguruma-dev
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# AMBIL COMPOSER RESMI LANGSUNG DARI IMAGE COMPOSER (Perbaikan di sini)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Salin kode proyek dan hasil build frontend
COPY --from=frontend-builder /app /var/www/html

# Jalankan Composer untuk menginstal library PHP Laravel
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-interaction --optimize-autoloader --no-dev --ignore-platform-reqs


# Atur izin folder Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Konfigurasi Nginx dasar untuk Laravel
RUN echo 'server { \
    listen 80; \
    root /var/www/html/public; \
    index index.php index.html; \
    location / { try_files $uri $uri/ /index.php?$query_string; } \
    location ~ \.php$ { \
        try_files $uri =404; \
        fastcgi_split_path_info ^(.+\.php)(/.+)$; \
        fastcgi_pass 127.0.0.1:9000; \
        fastcgi_index index.php; \
        include fastcgi_params; \
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
        fastcgi_param PATH_INFO $fastcgi_path_info; \
    } \
}' > /etc/nginx/http.d/default.conf

EXPOSE 80

# Pastikan baris paling bawah Dockerfile kamu polos seperti ini:
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]


