import { useState } from 'react';
import { Container, SectionTitle } from '../common';
import { useMultipleScrollAnimation } from '../../hooks/useScrollAnimation';
import { useT } from '../../i18n';
import styles from './FAQ.module.css';

function ChevronIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <polyline points="6 9 12 15 18 9" />
    </svg>
  );
}

export function FAQ() {
  const t = useT();
  const items = t.faq.items;
  const [openIndex, setOpenIndex] = useState(0);
  const [setRef, visibleItems] = useMultipleScrollAnimation(items.length, {
    threshold: 0.05,
    staggerDelay: 50,
  });

  const toggle = (index) => {
    setOpenIndex(openIndex === index ? -1 : index);
  };

  return (
    <section className={styles.section} id="faq">
      <Container size="small">
        <SectionTitle
          eyebrow={t.faq.eyebrow}
          title={t.faq.title}
          subtitle={t.faq.subtitle}
          gradient
        />

        <ul className={styles.list}>
          {items.map((faq, index) => {
            const isOpen = openIndex === index;
            return (
              <li
                key={index}
                ref={setRef(index)}
                className={`${styles.item} ${isOpen ? styles.open : ''} ${visibleItems[index] ? styles.visible : ''}`}
              >
                <button
                  type="button"
                  className={styles.question}
                  onClick={() => toggle(index)}
                  aria-expanded={isOpen}
                  aria-controls={`faq-answer-${index}`}
                >
                  <span>{faq.question}</span>
                  <span className={styles.icon} aria-hidden="true">
                    <ChevronIcon />
                  </span>
                </button>
                <div
                  id={`faq-answer-${index}`}
                  className={styles.answer}
                  role="region"
                  aria-hidden={!isOpen}
                >
                  <p>{faq.answer}</p>
                </div>
              </li>
            );
          })}
        </ul>
      </Container>
    </section>
  );
}

export default FAQ;
