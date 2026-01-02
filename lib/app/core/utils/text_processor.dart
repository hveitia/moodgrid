/// Utility class for text processing operations
/// Used for word cloud generation and text analysis
class TextProcessor {
  // Spanish stopwords - only truly empty words (articles, prepositions, etc.)
  // Excludes words that might be emotionally relevant (trabajo, familia, amigos, etc.)
  static const Set<String> _spanishStopwords = {
    // Articles
    'el', 'la', 'los', 'las', 'un', 'una', 'unos', 'unas',
    // Prepositions
    'a', 'ante', 'bajo', 'con', 'contra', 'de', 'desde', 'en', 'entre',
    'hacia', 'hasta', 'para', 'por', 'según', 'sin', 'sobre', 'tras',
    // Conjunctions
    'y', 'e', 'o', 'u', 'ni', 'que', 'pero', 'sino', 'aunque', 'porque',
    'pues', 'como', 'si', 'cuando', 'donde', 'mientras',
    // Pronouns
    'yo', 'tú', 'tu', 'él', 'ella', 'nosotros', 'vosotros', 'ellos', 'ellas',
    'me', 'te', 'se', 'nos', 'os', 'le', 'les', 'lo',
    'mi', 'mis', 'su', 'sus', 'nuestro', 'nuestra', 'nuestros', 'nuestras',
    'este', 'esta', 'esto', 'estos', 'estas', 'ese', 'esa', 'eso', 'esos', 'esas',
    'aquel', 'aquella', 'aquello', 'aquellos', 'aquellas',
    'quien', 'quienes', 'cual', 'cuales', 'cuyo', 'cuya', 'cuyos', 'cuyas',
    // Auxiliary verbs (ser, estar, haber)
    'ser', 'es', 'soy', 'eres', 'somos', 'son', 'era', 'fue', 'sido', 'siendo',
    'estar', 'estoy', 'está', 'estás', 'estamos', 'están', 'estuvo', 'estado',
    'haber', 'hay', 'ha', 'he', 'has', 'hemos', 'han', 'había', 'hubo',
    // Modal and common auxiliary verbs
    'tener', 'tengo', 'tiene', 'tienes', 'tenemos', 'tienen', 'tenía', 'tuvo',
    'poder', 'puedo', 'puede', 'puedes', 'podemos', 'pueden', 'pudo',
    'deber', 'debo', 'debe', 'debes', 'debemos', 'deben', 'debió',
    'ir', 'voy', 'va', 'vas', 'vamos', 'van', 'ido',
    'hacer', 'hago', 'hace', 'haces', 'hacemos', 'hacen', 'hizo', 'hecho',
    'dar', 'doy', 'da', 'das', 'damos', 'dan', 'dio', 'dado',
    'decir', 'digo', 'dice', 'dices', 'decimos', 'dicen', 'dijo', 'dicho',
    'ver', 'veo', 've', 'ves', 'vemos', 'ven', 'vio', 'visto',
    'saber', 'sé', 'sabe', 'sabes', 'sabemos', 'saben', 'supo',
    'querer', 'quiero', 'quiere', 'quieres', 'queremos', 'quieren', 'quiso',
    'poner', 'pongo', 'pone', 'pones', 'ponemos', 'ponen', 'puso', 'puesto',
    'parecer', 'parece', 'parecen', 'pareció',
    'quedar', 'quedo', 'queda', 'quedas', 'quedamos', 'quedan', 'quedó',
    'llevar', 'llevo', 'lleva', 'llevas', 'llevamos', 'llevan', 'llevó',
    'seguir', 'sigo', 'sigue', 'sigues', 'seguimos', 'siguen', 'siguió',
    'encontrar', 'encuentro', 'encuentra', 'encuentras', 'encontramos', 'encuentran',
    'llamar', 'llamo', 'llama', 'llamas', 'llamamos', 'llaman', 'llamó',
    'venir', 'vengo', 'viene', 'vienes', 'venimos', 'vienen', 'vino',
    'salir', 'salgo', 'sale', 'sales', 'salimos', 'salen', 'salió',
    'volver', 'vuelvo', 'vuelve', 'vuelves', 'volvemos', 'vuelven', 'volvió',
    'tomar', 'tomo', 'toma', 'tomas', 'tomamos', 'toman', 'tomó',
    'pasar', 'paso', 'pasa', 'pasas', 'pasamos', 'pasan', 'pasó',
    'llegar', 'llego', 'llega', 'llegas', 'llegamos', 'llegan', 'llegó',
    'creer', 'creo', 'cree', 'crees', 'creemos', 'creen', 'creyó',
    'hablar', 'hablo', 'habla', 'hablas', 'hablamos', 'hablan', 'habló',
    'empezar', 'empiezo', 'empieza', 'empiezas', 'empezamos', 'empiezan', 'empezó',
    'acabar', 'acabo', 'acaba', 'acabas', 'acabamos', 'acaban', 'acabó',
    'comenzar', 'comienzo', 'comienza', 'comienzas', 'comenzamos', 'comienzan',
    'terminar', 'termino', 'termina', 'terminas', 'terminamos', 'terminan',
    'usar', 'uso', 'usa', 'usas', 'usamos', 'usan', 'usó',
    // Adverbs
    'no', 'sí', 'muy', 'más', 'menos', 'ya', 'también', 'tampoco',
    'siempre', 'nunca', 'jamás', 'ahora', 'hoy', 'ayer',
    'antes', 'después', 'luego', 'pronto', 'temprano',
    'aquí', 'ahí', 'allí', 'acá', 'allá', 'cerca', 'lejos',
    'dentro', 'fuera', 'arriba', 'abajo', 'delante', 'detrás',
    'bien', 'mal', 'mejor', 'peor', 'así', 'tal', 'tan',
    'poco', 'bastante', 'demasiado', 'casi', 'solo', 'sólo',
    'además', 'incluso', 'aún', 'todavía', 'apenas', 'quizá', 'quizás',
    // Quantifiers and determiners
    'todo', 'toda', 'todos', 'todas', 'otro', 'otra', 'otros', 'otras',
    'mismo', 'misma', 'mismos', 'mismas', 'algo', 'alguien', 'alguno',
    'alguna', 'algunos', 'algunas', 'ninguno', 'ninguna', 'ningunos',
    'nada', 'nadie', 'cada', 'cualquier', 'cualquiera',
    'ambos', 'ambas', 'varios', 'varias', 'demás',
    'tanto', 'tanta', 'tantos', 'tantas', 'poca', 'pocos', 'pocas',
    'mucho', 'mucha', 'muchos', 'muchas',
    // Generic time/space words
    'vez', 'veces', 'cosa', 'cosas', 'caso', 'casos',
    'lado', 'lados', 'punto', 'puntos', 'modo', 'modos', 'manera', 'maneras',
    'forma', 'formas', 'tipo', 'tipos', 'parte', 'partes',
    // Question words
    'qué', 'quién', 'quiénes', 'cuál', 'cuáles', 'cuánto', 'cuánta',
    'cuántos', 'cuántas', 'cómo', 'dónde', 'cuándo',
    // Short common words
    'etc', 'sr', 'sra', 'dr', 'dra', 'don', 'doña',
  };

  /// Tokenize text into individual words
  /// Returns lowercase words, removing punctuation and numbers
  static List<String> tokenize(String text) {
    if (text.isEmpty) return [];

    // Convert to lowercase
    final lowerText = text.toLowerCase();

    // Remove punctuation and split by whitespace
    // Keep only letters (including accented characters)
    final cleaned = lowerText.replaceAll(RegExp(r'[^\p{L}\s]', unicode: true), ' ');

    // Split and filter empty strings
    final words = cleaned
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty && word.length > 1)
        .toList();

    return words;
  }

  /// Filter out stopwords from a list of words
  static List<String> filterStopwords(List<String> words) {
    return words.where((word) => !_spanishStopwords.contains(word)).toList();
  }

  /// Tokenize and filter stopwords in one step
  static List<String> processText(String text) {
    return filterStopwords(tokenize(text));
  }

  /// Calculate word frequencies from a list of texts
  /// Returns a map of word -> frequency
  static Map<String, int> calculateFrequencies(List<String> texts) {
    final frequencies = <String, int>{};

    for (final text in texts) {
      final words = processText(text);
      for (final word in words) {
        frequencies[word] = (frequencies[word] ?? 0) + 1;
      }
    }

    return frequencies;
  }

  /// Check if a word is a stopword
  static bool isStopword(String word) {
    return _spanishStopwords.contains(word.toLowerCase());
  }
}
