import '../models/app_info.dart';
import '../models/catalog.dart';

/// Embedded fallback catalog — used when the remote fetch fails (no network).
///
/// Keep this in sync with catalog.json.
const Catalog fallbackCatalog = Catalog(
  sectionTitles: {
    'en': 'Discover our apps',
    'fr': 'Découvre nos apps',
    'es': 'Descubre nuestras apps',
    'de': 'Entdecke unsere Apps',
    'it': 'Scopri le nostre app',
    'pt': 'Descobre as nossas apps',
    'nl': 'Ontdek onze apps',
  },
  buttonLabels: {
    'en': 'Get',
    'fr': 'Obtenir',
    'es': 'Obtener',
    'de': 'Laden',
    'it': 'Ottieni',
    'pt': 'Obter',
    'nl': 'Download',
  },
  apps: [
    AppInfo(
      id: 'tic_tac_go',
      name: 'Tic Tac Go!',
      descriptions: {
        'en': "The ultimate party game!",
        'fr': "Le jeu de soirée ultime !",
        'es': "¡El juego de fiesta definitivo!",
        'de': "Das ultimative Partyspiel!",
        'it': "Il gioco di società definitivo!",
        'pt': "O jogo de festa definitivo!",
        'nl': "Het ultieme partyspel!",
      },
      icon: 'tic_tac_go.png',
      appStoreUrl: 'https://apps.apple.com/app/tic-tac-go/id6761271201',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=studio.happyapp.tictacgo',
    ),
    AppInfo(
      id: 'aouh',
      name: 'Aouh',
      descriptions: {
        'en': 'The Werewolf game on mobile',
        'fr': 'Le Loup-Garou sur mobile',
        'es': 'El Hombre Lobo en el móvil',
        'de': 'Das Werwolf-Spiel auf dem Handy',
        'it': 'Il Lupo Mannaro sul cellulare',
        'pt': 'O Lobisomem no telemóvel',
        'nl': 'Het Weerwolf-spel op je mobiel',
      },
      icon: 'aouh.webp',
      appStoreUrl: 'https://apps.apple.com/app/aouh/id6759094186',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=studio.happyapp.aouh',
    ),
  ],
);
