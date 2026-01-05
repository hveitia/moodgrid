import { Header, Footer } from './components/layout';
import { Hero, Features, Screenshots, FAQ, CTA } from './components/sections';
import './styles/globals.css';

function App() {
  return (
    <>
      <Header />
      <main>
        <Hero />
        <Features />
        <Screenshots />
        <FAQ />
        <CTA />
      </main>
      <Footer />
    </>
  );
}

export default App;
