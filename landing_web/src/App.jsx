import { Header, Footer } from './components/layout';
import {
  Hero,
  YearReveal,
  HowItWorks,
  Features,
  Screenshots,
  Privacy,
  FAQ,
  CTA,
} from './components/sections';
import './styles/globals.css';

function App() {
  return (
    <>
      <Header />
      <main>
        <Hero />
        <YearReveal />
        <HowItWorks />
        <Features />
        <Screenshots />
        <Privacy />
        <FAQ />
        <CTA />
      </main>
      <Footer />
    </>
  );
}

export default App;
