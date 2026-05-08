export const translations = {
  en: {
    nav: {
      ariaLabel: 'Main navigation',
      howItWorks: 'How it works',
      features: 'Features',
      screenshots: 'Screenshots',
      privacy: 'Privacy',
      faq: 'FAQ',
      openMenu: 'Open menu',
      closeMenu: 'Close menu',
      appStoreAria: 'Download on the App Store',
      playStoreAria: 'Get it on Google Play',
    },
    cta: {
      downloadOn: 'Download on',
      appStore: 'App Store',
      playStore: 'Google Play',
    },
    hero: {
      eyebrow: 'Mood tracker · Mental health',
      titleLine1: 'Your emotional year,',
      titleLine2: 'in a single image.',
      description:
        'Log how you feel each day with one tap. Spot patterns, write in your journal, and understand your emotions better.',
      mockupAlt: 'EmotionsMap home screen showing the monthly mood grid',
      trust: {
        private: '100% private',
        offline: 'Works offline',
      },
      legend: '5 mood states',
      scrollHint: 'Discover how it works',
    },
    yearReveal: {
      eyebrow: 'The wow moment',
      title: 'Your year, in a single image.',
      subtitle:
        'One tap a day. 365 days later, your emotional year becomes a mosaic that tells your story.',
      frameTitle: 'My Year in Pixels',
      progress: '{n}% complete',
      legend: {
        excellent: 'Excellent',
        good: 'Good',
        neutral: 'Neutral',
        difficult: 'Difficult',
        bad: 'Bad',
      },
      caption: 'Scroll to watch your year fill in.',
      ariaProgress: 'Year visualization {n}% complete',
    },
    howItWorks: {
      eyebrow: 'As simple as breathing',
      title: 'How it works',
      subtitle: 'Three steps. No forms, no accounts, no friction.',
      steps: [
        {
          title: 'Tap a day',
          description: 'Open EmotionsMap, look at your grid, and tap today.',
        },
        {
          title: 'Pick how you felt',
          description: 'Excellent, Good, Neutral, Difficult or Bad. Takes 3 seconds.',
        },
        {
          title: 'See the patterns',
          description: 'Day by day your mosaic fills up. Trends emerge on their own.',
        },
      ],
    },
    features: {
      eyebrow: 'Thoughtful features',
      title: 'Small features, big shifts.',
      subtitle:
        'Everything you need to better understand your emotions, without overwhelming you.',
      items: [
        {
          title: 'Monthly mosaic',
          description:
            'See each month as a colorful grid. Every cell is a day painted with your mood.',
        },
        {
          title: 'Year in pixels',
          description: '365 days on a single screen. Your emotional life, in perspective.',
        },
        {
          title: 'Journal with search',
          description: 'Write down what your days were like. Search through your reflections.',
        },
        {
          title: 'Word cloud',
          description: 'The words you use most, colored by the mood you associate with them.',
        },
        {
          title: 'Statistics',
          description:
            'Mood distribution, streaks, your most productive month. Without obsessing.',
        },
        {
          title: 'PIN lock',
          description: 'Your journal, only yours. Protect it with a PIN.',
        },
        {
          title: 'Export & import',
          description: 'Your data as JSON or images. Export, import, share.',
        },
      ],
    },
    screenshots: {
      eyebrow: 'Screenshots',
      title: 'Polished down to the last detail.',
      subtitle: 'A simple, warm and distraction-free interface. Made to come back to every day.',
      items: [
        { title: 'Monthly mosaic', caption: 'Your month in colors' },
        { title: 'Year in pixels', caption: '365 days, one image' },
        { title: 'My journal', caption: 'Your reflections, day by day' },
        { title: 'Word cloud', caption: 'What lives in your head' },
        { title: 'My profile', caption: 'Your statistics' },
      ],
      ariaPrev: 'Previous screenshot',
      ariaNext: 'Next screenshot',
      ariaSee: 'View screenshot:',
      ariaList: 'Screenshots',
      ariaGoTo: 'Go to screenshot',
    },
    privacy: {
      eyebrow: 'Privacy by design',
      titleBefore: 'Your emotions are',
      titleEm: 'only',
      titleAfter: 'yours.',
      subtitle:
        'We don\'t upload anything to a server. We don\'t profile you. If EmotionsMap disappeared tomorrow, your data would still live on your device, intact.',
      cta: 'Download and start',
      points: [
        {
          title: '100% local',
          description:
            'Your emotions never leave your phone. Local SQLite, no cloud sync.',
        },
        {
          title: 'No account, no internet',
          description: 'Works offline from day one. No email, signup or phone number.',
        },
        {
          title: 'We don\'t sell your data',
          description: 'Your information is yours. We never sell or share it with third parties.',
        },
        {
          title: 'PIN lock',
          description: 'Protect your journal so no one can read it, not even with your phone.',
        },
      ],
    },
    faq: {
      eyebrow: 'Frequently asked questions',
      title: 'Got questions?',
      subtitle: 'If anything is still unclear, write us. We\'re here.',
      items: [
        {
          question: 'Is EmotionsMap free?',
          answer:
            'Yes, EmotionsMap is free to download and use. All core features are available from day one.',
        },
        {
          question: 'Is my data safe?',
          answer:
            'Your data is stored locally on your device in an encrypted SQLite database. Nothing is uploaded to any server. You can lock the app with a PIN and export backups whenever you want.',
        },
        {
          question: 'Can I export my data?',
          answer:
            'Yes. You can export your full history as a JSON file for backup. You can also generate images of your year in pixels or a specific month to share.',
        },
        {
          question: 'Is it available on iOS and Android?',
          answer:
            'Yes, on the App Store for iPhone and Google Play for Android. The experience is the same on both platforms.',
        },
        {
          question: 'Does it need an internet connection?',
          answer:
            'No. EmotionsMap works 100% offline. You only need internet for the initial download.',
        },
        {
          question: 'How is the word cloud built?',
          answer:
            'We analyze the words in your daily reflections locally on your device. Size shows frequency and color reflects the average mood associated with each word.',
        },
      ],
    },
    finalCta: {
      titleBefore: 'Start understanding',
      titleEm: 'your emotions',
      titleAfter: 'today.',
      description:
        'Download EmotionsMap and, with one tap a day, give shape to your emotional year.',
      qrIphone: 'Scan with your iPhone',
      qrAndroid: 'Scan with your Android',
    },
    footer: {
      tagline: 'Visualize your emotions, take care of your wellbeing.',
      product: 'Product',
      download: 'Download',
      legal: 'Legal',
      links: {
        howItWorks: 'How it works',
        features: 'Features',
        screenshots: 'Screenshots',
        faq: 'FAQ',
        appStore: 'App Store',
        playStore: 'Google Play',
        privacy: 'Privacy',
        terms: 'Terms',
        support: 'Support',
      },
      copyright: '© {year} EmotionsMap',
      madeWith: 'Made with care for your wellbeing',
    },
    languageSwitch: {
      ariaLabel: 'Change language',
      en: 'English',
      es: 'Spanish',
    },
  },

  es: {
    nav: {
      ariaLabel: 'Navegación principal',
      howItWorks: 'Cómo funciona',
      features: 'Características',
      screenshots: 'Capturas',
      privacy: 'Privacidad',
      faq: 'FAQ',
      openMenu: 'Abrir menú',
      closeMenu: 'Cerrar menú',
      appStoreAria: 'Descargar en App Store',
      playStoreAria: 'Descargar en Google Play',
    },
    cta: {
      downloadOn: 'Descargar en',
      appStore: 'App Store',
      playStore: 'Google Play',
    },
    hero: {
      eyebrow: 'Mood tracker · Salud mental',
      titleLine1: 'Tu año emocional,',
      titleLine2: 'en una sola imagen.',
      description:
        'Registra cómo te sientes cada día con un toque. Descubre patrones, escribe en tu diario y entiende mejor tus emociones.',
      mockupAlt: 'Pantalla principal de EmotionsMap mostrando el grid mensual de estados de ánimo',
      trust: {
        private: '100% privado',
        offline: 'Funciona offline',
      },
      legend: '5 estados de ánimo',
      scrollHint: 'Descubre cómo funciona',
    },
    yearReveal: {
      eyebrow: 'El wow moment',
      title: 'Tu año, en una sola imagen.',
      subtitle:
        'Un toque al día. 365 días después, tu año emocional se convierte en un mosaico que cuenta tu historia.',
      frameTitle: 'Mi Año en Píxeles',
      progress: '{n}% completado',
      legend: {
        excellent: 'Excelente',
        good: 'Bien',
        neutral: 'Neutral',
        difficult: 'Difícil',
        bad: 'Mal',
      },
      caption: 'Haz scroll para ver cómo se llena tu año.',
      ariaProgress: 'Visualización del año {n}% completada',
    },
    howItWorks: {
      eyebrow: 'Tan simple como respirar',
      title: 'Cómo funciona',
      subtitle: 'Tres pasos. Sin formularios, sin cuentas, sin fricciones.',
      steps: [
        {
          title: 'Toca un día',
          description: 'Abre EmotionsMap, mira tu grid y toca el día de hoy.',
        },
        {
          title: 'Elige tu estado',
          description: 'Excelente, Bien, Neutral, Difícil o Mal. Toma 3 segundos.',
        },
        {
          title: 'Descubre patrones',
          description: 'Día tras día tu mosaico se llena. Las tendencias aparecen solas.',
        },
      ],
    },
    features: {
      eyebrow: 'Funciones cuidadas',
      title: 'Pequeñas funciones, grandes cambios.',
      subtitle:
        'Todo lo que necesitas para entender mejor tus emociones, sin sobrecargarte.',
      items: [
        {
          title: 'Mosaico mensual',
          description:
            'Visualiza cada mes con un grid colorido. Cada celda es un día pintado con tu estado de ánimo.',
        },
        {
          title: 'Año en píxeles',
          description: '365 días en una sola pantalla. Tu vida emocional, en perspectiva.',
        },
        {
          title: 'Diario con búsqueda',
          description:
            'Anota lo que vivieron tus días. Busca momentos en tus reflexiones.',
        },
        {
          title: 'Nube de palabras',
          description: 'Las palabras que más usas, coloreadas según el ánimo asociado.',
        },
        {
          title: 'Estadísticas',
          description:
            'Distribución de estados, rachas, mes más productivo. Sin obsesionarte.',
        },
        {
          title: 'Bloqueo con PIN',
          description: 'Tu diario, tuyo y de nadie más. Protégelo con un PIN.',
        },
        {
          title: 'Export e import',
          description: 'Tus datos como JSON o imágenes. Exporta, importa, comparte.',
        },
      ],
    },
    screenshots: {
      eyebrow: 'Capturas',
      title: 'Cuidada hasta el último detalle.',
      subtitle:
        'Una interfaz simple, cálida y sin distracciones. Pensada para volver cada día.',
      items: [
        { title: 'Mosaico mensual', caption: 'Tu mes en colores' },
        { title: 'Año en píxeles', caption: '365 días, una imagen' },
        { title: 'Mi diario', caption: 'Tus reflexiones, día a día' },
        { title: 'Nube de palabras', caption: 'Lo que más te ocupa' },
        { title: 'Mi perfil', caption: 'Tus estadísticas' },
      ],
      ariaPrev: 'Captura anterior',
      ariaNext: 'Siguiente captura',
      ariaSee: 'Ver captura:',
      ariaList: 'Capturas',
      ariaGoTo: 'Ir a captura',
    },
    privacy: {
      eyebrow: 'Privacidad por diseño',
      titleBefore: 'Tus emociones',
      titleEm: 'solo',
      titleAfter: 'son tuyas.',
      subtitle:
        'No subimos nada a un servidor. No te perfilamos. Si EmotionsMap desapareciera mañana, tus datos seguirían en tu dispositivo, intactos.',
      cta: 'Descargar y empezar',
      points: [
        {
          title: '100% local',
          description:
            'Tus emociones nunca salen de tu teléfono. SQLite local, sin sincronización en la nube.',
        },
        {
          title: 'Sin cuenta, sin internet',
          description:
            'Funciona offline desde el primer día. No te pedimos email, registro ni teléfono.',
        },
        {
          title: 'No vendemos tus datos',
          description: 'Tu información es tuya. Nunca la vendemos ni la compartimos con terceros.',
        },
        {
          title: 'Bloqueo con PIN',
          description:
            'Protege tu diario para que nadie lo lea, ni siquiera quien tenga tu teléfono.',
        },
      ],
    },
    faq: {
      eyebrow: 'Preguntas frecuentes',
      title: '¿Resolvemos tus dudas?',
      subtitle: 'Si te queda alguna pregunta, escríbenos. Estamos aquí.',
      items: [
        {
          question: '¿Es EmotionsMap gratuito?',
          answer:
            'Sí, EmotionsMap es gratis para descargar y usar. Todas las funciones principales están disponibles desde el primer día.',
        },
        {
          question: '¿Mis datos están seguros?',
          answer:
            'Tus datos se guardan localmente en tu dispositivo en una base de datos SQLite cifrada. No se suben a ningún servidor. Puedes proteger la app con un PIN y exportar respaldos cuando quieras.',
        },
        {
          question: '¿Puedo exportar mis datos?',
          answer:
            'Sí. Puedes exportar todo tu historial como archivo JSON para hacer backup. También puedes generar imágenes de tu año en píxeles o de un mes en concreto para compartir.',
        },
        {
          question: '¿Está disponible en iOS y Android?',
          answer:
            'Sí, en App Store para iPhone y en Google Play para Android. La experiencia es la misma en ambas plataformas.',
        },
        {
          question: '¿Necesita conexión a internet?',
          answer:
            'No. EmotionsMap funciona 100% offline. Solo necesitas internet para la primera descarga.',
        },
        {
          question: '¿Cómo se construye la nube de palabras?',
          answer:
            'Analizamos las palabras de tus reflexiones diarias localmente, en tu dispositivo. El tamaño indica frecuencia y el color refleja el estado de ánimo promedio asociado a cada palabra.',
        },
      ],
    },
    finalCta: {
      titleBefore: 'Empieza a entender',
      titleEm: 'tus emociones',
      titleAfter: 'hoy.',
      description:
        'Descarga EmotionsMap y, en un toque al día, dale forma a tu año emocional.',
      qrIphone: 'Escanéalo con tu iPhone',
      qrAndroid: 'Escanéalo con tu Android',
    },
    footer: {
      tagline: 'Visualiza tus emociones, cuida tu bienestar.',
      product: 'Producto',
      download: 'Descarga',
      legal: 'Legal',
      links: {
        howItWorks: 'Cómo funciona',
        features: 'Características',
        screenshots: 'Capturas',
        faq: 'FAQ',
        appStore: 'App Store',
        playStore: 'Google Play',
        privacy: 'Privacidad',
        terms: 'Términos',
        support: 'Soporte',
      },
      copyright: '© {year} EmotionsMap',
      madeWith: 'Hecho con cuidado para tu bienestar',
    },
    languageSwitch: {
      ariaLabel: 'Cambiar idioma',
      en: 'Inglés',
      es: 'Español',
    },
  },
};

export const SUPPORTED_LANGUAGES = ['en', 'es'];
export const DEFAULT_LANGUAGE = 'en';
