import '../models/app_info.dart';
import '../models/catalog.dart';

/// Embedded fallback catalog — used when the remote fetch fails (no network).
///
/// Keep this in sync with catalog.json.
const Catalog fallbackCatalog = Catalog(
  sectionTitles: {
    'en': 'Discover our other apps',
    'fr': 'Découvre nos autres apps',
    'es': 'Descubre nuestras otras apps',
    'de': 'Entdecke unsere anderen Apps',
    'it': 'Scopri le nostre altre app',
    'pt': 'Descobre as nossas outras apps',
    'nl': 'Ontdek onze andere apps',
  },
  buttonLabels: {
    'en': 'Discover',
    'fr': 'Découvrir',
    'es': 'Descubrir',
    'de': 'Entdecken',
    'it': 'Scopri',
    'pt': 'Descobrir',
    'nl': 'Ontdek',
  },
  apps: [
    AppInfo(
      id: 'doku',
      name: 'Doku',
      descriptions: {
        'en': 'Daily sudoku: metro, countries, Pokémon',
        'fr': 'Le sudoku du jour : métro, pays, Pokémon',
        'es': 'El sudoku diario: metro, países, Pokémon',
        'de': 'Das tägliche Sudoku: U-Bahn, Länder, Pokémon',
        'it': 'Il sudoku del giorno: metro, paesi, Pokémon',
        'pt': 'O sudoku diário: metro, países, Pokémon',
        'nl': 'De dagelijkse sudoku: metro, landen, Pokémon',
      },
      icon: 'doku.webp',
      appStoreUrl: 'https://apps.apple.com/app/doku/id6777248325',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=studio.happyapp.doku',
      videos: {
        'fr': 'https://happyapp.studio/apps/doku/promo/doku-pays-fr-v1.mp4',
        'en': 'https://happyapp.studio/apps/doku/promo/doku-pays-en-v1.mp4',
      },
    ),
    AppInfo(
      id: 'aouh',
      name: 'Aouh',
      descriptions: {
        'en': 'Werewolf with no cards and no narrator',
        'fr': 'Le Loup-Garou sans cartes ni meneur',
        'es': 'El Hombre Lobo sin cartas ni narrador',
        'de': 'Werwolf ohne Karten und ohne Erzähler',
        'it': 'Lupus in Tabula senza carte né narratore',
        'pt': 'O Lobisomem sem cartas nem narrador',
        'nl': 'Weerwolven zonder kaarten of verteller',
      },
      icon: 'aouh.webp',
      appStoreUrl: 'https://apps.apple.com/app/aouh/id6759094186',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=studio.happyapp.aouh',
    ),
    AppInfo(
      id: 'happy_hour',
      name: 'Pypo',
      descriptions: {
        'en': 'Party games for your nights with friends',
        'fr': 'Les jeux de soirée entre amis',
        'es': 'Juegos de fiesta entre amigos',
        'de': 'Partyspiele für Abende mit Freunden',
        'it': 'Giochi da festa tra amici',
        'pt': 'Jogos de festa entre amigos',
        'nl': 'Partyspellen voor avonden met vrienden',
      },
      icon: 'happy_hour.webp',
      appStoreUrl:
          'https://apps.apple.com/us/app/happyhour-party-games/id1536798029',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=happyapp.happyhour',
    ),
    AppInfo(
      id: 'tic_tac_go',
      name: 'Tic Tac Go!',
      descriptions: {
        'en': "Time's Up with friends, no cards needed",
        'fr': "Le Time's Up entre amis, sans cartes",
        'es': "El Time's Up entre amigos, sin cartas",
        'de': "Time's Up mit Freunden, ganz ohne Karten",
        'it': "Time's Up tra amici, senza carte",
        'pt': "O Time's Up entre amigos, sem cartas",
        'nl': "Time's Up met vrienden, zonder kaarten",
      },
      icon: 'tic_tac_go.webp',
      appStoreUrl: 'https://apps.apple.com/app/tic-tac-go/id6761271201',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=studio.happyapp.tictacgo',
    ),
    AppInfo(
      id: 'rise',
      name: 'Rise',
      descriptions: {
        'en': 'Break free from addiction, day by day',
        'fr': 'Libère-toi de tes addictions, pas à pas',
        'es': 'Libérate de tus adicciones, día a día',
        'de': 'Befrei dich Tag für Tag von deiner Sucht',
        'it': 'Liberati dalle dipendenze, ogni giorno',
        'pt': 'Liberta-te dos teus vícios, dia após dia',
        'nl': 'Bevrijd je van je verslaving, dag na dag',
      },
      icon: 'rise.webp',
      appStoreUrl: 'https://apps.apple.com/app/rise/id6760611764',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=studio.happyapp.rise',
    ),
  ],
);
