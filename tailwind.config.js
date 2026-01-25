import defaultTheme from 'tailwindcss/defaultTheme';
import forms from '@tailwindcss/forms';
import flyonui from 'flyonui';

/** @type {import('tailwindcss').Config} */
export default {
    content: [
        './vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
        './resources/js/**/*.vue',
        './node_modules/flyonui/dist/js/*.js',
    ],

    theme: {
        extend: {
            fontFamily: {
                sans: ['Inter', ...defaultTheme.fontFamily.sans],
                arabic: ['Amiri', 'Scheherazade New', 'serif'],
            },
            colors: {
                // Bakri Islamic Palette
                primary: {
                    50: '#f1fafa',
                    100: '#daefef',
                    200: '#baebf0',
                    300: '#8ed9e3',
                    400: '#58c0cf',
                    500: '#068d9e', // Bakri Teal
                    600: '#057d8c',
                    700: '#046773',
                    800: '#03555e',
                    900: '#02464e',
                    950: '#012a2f',
                },
                secondary: {
                    50: '#f6fbe8',
                    100: '#ebf7cf',
                    200: '#d7efa4',
                    300: '#c2e779',
                    400: '#addf4e',
                    500: '#a4d233', // Bakri Lime
                    600: '#8abd29',
                    700: '#6fa521',
                    800: '#5a861d',
                    900: '#4a6e1a',
                    950: '#2a3f0f',
                },
                bakri: {
                    teal: '#068d9e',
                    lime: '#a4d233',
                    navy: '#012a2f',
                    white: '#ffffff',
                }
            },
            boxShadow: {
                soft: '0 2px 15px -3px rgba(0, 0, 0, 0.07), 0 10px 20px -2px rgba(0, 0, 0, 0.04)',
                islamic: '0 4px 20px -2px rgba(5, 150, 105, 0.1), 0 2px 10px -1px rgba(5, 150, 105, 0.06)',
            },
            backgroundImage: {
                'gradient-bakri': 'linear-gradient(135deg, #068d9e 0%, #a4d233 100%)',
                'gradient-teal': 'linear-gradient(135deg, #068d9e 0%, #057d8c 100%)',
                'pattern-islamic': "url('data:image/svg+xml,%3Csvg width=\"60\" height=\"60\" viewBox=\"0 0 60 60\" xmlns=\"http://www.w3.org/2000/svg\"%3E%3Cg fill=\"none\" fill-rule=\"evenodd\"%3E%3Cg fill=\"%23068d9e\" fill-opacity=\"0.05\"%3E%3Cpath d=\"M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z\"/%3E%3C/g%3E%3C/g%3E%3C/svg%3E')",
            },
            animation: {
                'fade-in': 'fadeIn 0.3s ease-in-out',
                'slide-up': 'slideUp 0.4s ease-out',
                'scale-in': 'scaleIn 0.2s ease-out',
                'shine': 'shine 2s infinite',
            },
            keyframes: {
                fadeIn: {
                    '0%': { opacity: '0' },
                    '100%': { opacity: '1' },
                },
                slideUp: {
                    '0%': { transform: 'translateY(10px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '1' },
                },
                scaleIn: {
                    '0%': { transform: 'scale(0.95)', opacity: '0' },
                    '100%': { transform: 'scale(1)', opacity: '1' },
                },
                shine: {
                    '0%': { transform: 'translateX(-100%)' },
                    '100%': { transform: 'translateX(100%)' },
                },
            },
        },
    },

    plugins: [forms, flyonui],

    // FlyonUI theme configuration
    flyonui: {
        themes: [
            {
                pimasjid: {
                    primary: '#158399',
                    secondary: '#b8926a',
                    accent: '#00a9d4',
                    neutral: '#1a2e5a',
                    'base-100': '#ffffff',
                    info: '#00a9d4',
                    success: '#158399',
                    warning: '#e67e22', // Updated to saffron for CTA
                    error: '#f43f5e',
                },
            },
            'light',
        ],
    },
};
