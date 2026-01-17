import "./globals.css";

export const metadata = {
  title: "Project Aura",
  description: "Settlement command center"
};

export default function RootLayout({
  children
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
