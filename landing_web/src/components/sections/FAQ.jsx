import { useState } from 'react';
import { Container, SectionTitle } from '../common';
import { useMultipleScrollAnimation } from '../../hooks/useScrollAnimation';
import styles from './FAQ.module.css';

const FAQS = [
  {
    question: '¿Es Feelmap gratuito?',
    answer: 'Sí, Feelmap es completamente gratuito. Disfruta de todas las funcionalidades sin costos ocultos ni suscripciones.',
  },
  {
    question: '¿Mis datos están seguros?',
    answer: 'Absolutamente. Tus datos se almacenan localmente en tu dispositivo. Puedes proteger la app con PIN y exportar backups cuando quieras. No recopilamos ni vendemos tu información personal.',
  },
  {
    question: '¿Puedo exportar mis datos?',
    answer: 'Sí, puedes exportar todo tu historial como archivo JSON para respaldo. También puedes compartir imágenes de tu año en píxeles o meses individuales en redes sociales.',
  },
  {
    question: '¿Está disponible en Android e iOS?',
    answer: 'Sí, Feelmap está disponible tanto en App Store para dispositivos iOS como en Google Play Store para dispositivos Android.',
  },
  {
    question: '¿Necesito conexión a internet?',
    answer: 'No, Feelmap funciona completamente offline. Solo necesitas conexión a internet para descargar la app inicialmente.',
  },
  {
    question: '¿Cómo funciona la nube de palabras?',
    answer: 'Analizamos las palabras de tus reflexiones diarias y mostramos las más frecuentes en forma visual. El tamaño indica la frecuencia y el color indica el estado de ánimo promedio asociado a cada palabra.',
  },
];

export function FAQ() {
  const [openIndex, setOpenIndex] = useState(null);
  const [setRef, visibleItems] = useMultipleScrollAnimation(FAQS.length, {
    threshold: 0.1,
    staggerDelay: 100,
  });

  const toggleFaq = (index) => {
    setOpenIndex(openIndex === index ? null : index);
  };

  return (
    <section className={styles.faq} id="faq">
      <Container size="small">
        <SectionTitle
          title="Preguntas Frecuentes"
          subtitle="Resolvemos tus dudas sobre Feelmap"
          gradient
        />

        <div className={styles.faqList}>
          {FAQS.map((faq, index) => (
            <div
              key={index}
              ref={setRef(index)}
              className={`${styles.faqItem} ${openIndex === index ? styles.open : ''} ${visibleItems[index] ? styles.visible : ''}`}
            >
              <button
                className={styles.faqQuestion}
                onClick={() => toggleFaq(index)}
                aria-expanded={openIndex === index}
              >
                <span>{faq.question}</span>
                <span className={styles.faqIcon}>
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M12 5v14M5 12h14"/>
                  </svg>
                </span>
              </button>
              <div className={styles.faqAnswer}>
                <p>{faq.answer}</p>
              </div>
            </div>
          ))}
        </div>
      </Container>
    </section>
  );
}

export default FAQ;
