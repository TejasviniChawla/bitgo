/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        aura: {
          900: "#0B0F1C",
          800: "#12172A",
          700: "#1A2140",
          200: "#C9D2FF",
          100: "#E2E8FF"
        }
      }
    }
  },
  plugins: []
};
