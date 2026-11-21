import type { Metadata } from 'next';
import './style.css';
export const metadata: Metadata = { title: 'ပဉ္စရာ | Admin', description: 'Pyinsara Store Admin Dashboard' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="my"><body>{children}</body></html>; }
