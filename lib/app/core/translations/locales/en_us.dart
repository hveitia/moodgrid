const Map<String, String> enUs = {
  // Common
  'common.cancel': 'Cancel',
  'common.confirm': 'Confirm',
  'common.save': 'Save',
  'common.delete': 'Delete',
  'common.edit': 'Edit',
  'common.close': 'Close',
  'common.back': 'Back',
  'common.next': 'Next',
  'common.done': 'Done',
  'common.loading': 'Loading…',
  'common.retry': 'Retry',
  'common.error': 'Error',
  'common.success': 'Success',
  'common.warning': 'Warning',
  'common.yes': 'Yes',
  'common.no': 'No',
  'common.ok': 'OK',
  'common.share': 'Share',
  'common.export': 'Export',
  'common.import': 'Import',
  'common.search': 'Search',

  // Mood labels (used by AppColors.getMoodText)
  'mood.label.excellent': 'Excellent',
  'mood.label.good': 'Good',
  'mood.label.neutral': 'Neutral',
  'mood.label.difficult': 'Difficult',
  'mood.label.bad': 'Bad',
  'mood.label.empty': 'No record',

  // Language
  'language.title': 'Language',
  'language.english': 'English',
  'language.spanish': 'Spanish',
  'language.system': 'System',
  'language.choose': 'Choose your language',

  // Profile
  'profile.title': 'My Profile',
  'profile.user_default': 'User',
  'profile.member_since': 'Member since @date',
  'profile.unknown_date': 'Unknown date',
  'profile.stats.title': 'Statistics',
  'profile.stats.subtitle': 'Analysis of your moods',
  'profile.stats.error_loading': 'Failed to load statistics',
  'profile.settings.title': 'Settings',
  'profile.settings.language.title': 'Language',
  'profile.settings.reminder.title': 'Daily reminder',
  'profile.settings.reminder.subtitle.on': 'Every day at @time',
  'profile.settings.reminder.subtitle.off': 'Turn it on to keep your streak',
  'profile.settings.reminder.permission_denied':
      'Enable notifications in your system settings',
  'profile.settings.reminder.notification.title': 'How are you feeling today?',
  'profile.settings.reminder.notification.body':
      'Take a moment to log your mood.',
  'profile.settings.security.title': 'Security',
  'profile.settings.security.subtitle': 'Set up your security PIN',
  'profile.settings.signout.title': 'Sign out',
  'profile.settings.signout.subtitle': 'Leave your account',
  'profile.danger.title': 'Danger zone',
  'profile.danger.delete.title': 'Delete account',
  'profile.danger.delete.subtitle': 'This action is permanent and irreversible',
  'profile.signout.dialog.title': 'Sign out',
  'profile.signout.dialog.message': 'Are you sure you want to sign out?',
  'profile.signout.dialog.confirm': 'Sign out',
  'profile.delete.dialog.title': 'Delete account',
  'profile.delete.dialog.question': 'Are you sure you want to delete your account?',
  'profile.delete.dialog.warning': 'This action is PERMANENT',
  'profile.delete.dialog.bullets':
      '• All your data will be deleted\n• You will lose your mood records\n• You will not be able to recover your account',
  'profile.delete.dialog.confirm': 'Delete permanently',

  // Home — appbar / tooltips / general
  'home.appbar.tooltip.grid': 'Grid view',
  'home.appbar.tooltip.chart': 'Chart view',
  'home.legend.title': 'Legend',
  'home.month.tooltip.export': 'Export month',
  'home.weekday.short.mon': 'Mon',
  'home.weekday.short.tue': 'Tue',
  'home.weekday.short.wed': 'Wed',
  'home.weekday.short.thu': 'Thu',
  'home.weekday.short.fri': 'Fri',
  'home.weekday.short.sat': 'Sat',
  'home.weekday.short.sun': 'Sun',

  // Home — record bottom sheet
  'home.record.tooltip.delete': 'Delete record',
  'home.record.title': 'How did you feel?',
  'home.record.comment.label': 'Comment (optional)',
  'home.record.comment.hint': 'Write a comment…',
  'home.record.button.save': 'Save',

  // Home — export bottom sheet
  'home.export.title': 'What do you want to export?',
  'home.export.grid.title': 'Grid view',
  'home.export.grid.subtitle': 'Export the month grid',
  'home.export.chart.title': 'Chart view',
  'home.export.chart.subtitle': 'Export the month chart',

  // Home — exporting dialog
  'home.exporting.title': 'Preparing export…',
  'home.exporting.subtitle': 'This will take a moment',

  // Home — share strings
  'home.share.backup.subject': 'EmotionsMap Backup',
  'home.share.backup.text': 'Backup of my EmotionsMap records',
  'home.share.month.subject': 'EmotionsMap - @month @year',
  'home.share.month.text': 'My mood record for @month @year',

  // Home — snackbars
  'home.snack.saved': 'Record saved successfully',
  'home.snack.deleted': 'Record deleted',
  'home.snack.imported.one': '@count record imported',
  'home.snack.imported.other': '@count records imported',
  'home.error.load': 'Error loading records: @e',
  'home.error.save': 'Error saving record: @e',
  'home.error.delete': 'Error deleting record: @e',
  'home.error.export': 'Error exporting: @e',
  'home.error.export_image': 'Error exporting image: @e',
  'home.error.import': 'Error importing: @e',

  // Drawer
  'drawer.welcome': 'Welcome to EmotionsMap',
  'drawer.section.main': 'MAIN',
  'drawer.section.tools': 'TOOLS',
  'drawer.section.info': 'INFO',
  'drawer.item.home': 'Home',
  'drawer.item.profile.title': 'My Profile',
  'drawer.item.profile.subtitle': 'See stats and settings',
  'drawer.item.reflections.title': 'Reflections',
  'drawer.item.reflections.subtitle': 'Writing statistics',
  'drawer.item.journal.title': 'My Journal',
  'drawer.item.journal.subtitle': 'See comments and reflections',
  'drawer.item.wordcloud.title': 'Word Cloud',
  'drawer.item.wordcloud.subtitle': 'Comment analysis',
  'drawer.item.backup.title': 'Data Backup',
  'drawer.item.backup.subtitle': 'Export and import',
  'drawer.item.security.title': 'Security',
  'drawer.item.security.subtitle': 'Set up PIN',
  'drawer.item.about.title': 'About',
  'drawer.item.about.subtitle': 'App information',
  'drawer.item.help.title': 'Help',
  'drawer.item.help.subtitle': 'Usage guide',
  'drawer.version': 'Version @version (@build)',

  // About dialog
  'about.title': 'About EmotionsMap',
  'about.description':
      'EmotionsMap is an app to track your daily mood in a visual and intuitive way.',
  'about.features.title': 'Features:',
  'about.features.bullets':
      '• Daily emotion logging.\n• Grid and chart visualization.\n• Detailed statistics.\n• Data and screenshot export.\n• Monthly image export.\n• PIN security.',

  // Help dialog
  'help.title': 'Usage Guide',
  'help.button.understood': 'Got it',
  'help.section.log.title': 'Log your mood',
  'help.section.log.body':
      'Tap any day on the grid to record how you felt that day.',
  'help.section.colors.title': 'Colors',
  'help.section.colors.body':
      'Each color represents a different mood:\n• Green: Excellent.\n• Blue: Good.\n• Yellow: Neutral.\n• Orange: Difficult.\n• Red: Bad.',
  'help.section.comments.title': 'Comments',
  'help.section.comments.body':
      'You can add notes to each day. Days with comments show a small note icon.',
  'help.section.views.title': 'Views',
  'help.section.views.body':
      'Switch between grid and chart view using the icons in the top bar:\n• Grid: shows your days as a calendar.\n• Chart: visualizes your moods as a bar chart.',
  'help.section.export.title': 'Export month',
  'help.section.export.body':
      'Tap the share icon on each month to export that month\'s image. You can share the screenshot in your favorite apps.',

  // Chart widget
  'home.chart.empty.title': 'No data for this month',
  'home.chart.empty.subtitle': 'Log your mood to see the chart',
  'home.chart.axis_label': 'Days of the month',

  // Landing
  'landing.tagline':
      'Log your mood day by day and visualize patterns in your emotional wellbeing.',
  'landing.button.signin': 'Sign in',
  'landing.button.signup': 'Create account',

  // Login
  'login.title': 'Sign in',
  'login.field.email': 'Email',
  'login.field.password': 'Password',
  'login.error.email_required': 'Please enter your email',
  'login.error.email_invalid': 'Please enter a valid email',
  'login.error.password_required': 'Please enter your password',
  'login.error.password_short': 'Password must be at least 6 characters',
  'login.button.submit': 'Sign in',
  'login.link.signup': 'Don\'t have an account? Sign up',
  'login.forgot.link': 'Forgot your password?',

  // Password recovery
  'recovery.title': 'Reset password',
  'recovery.subtitle':
      'Enter your email and we\'ll send you a link to reset your password.',
  'recovery.field.email': 'Email',
  'recovery.button.send': 'Send link',
  'recovery.success.title': 'Email sent',
  'recovery.success.message':
      'Check your inbox to reset your password. If you can\'t find it, check your spam or junk folder too.',
  'recovery.error.missing_email': 'Please enter your email',
  'recovery.error.generic': 'Could not send the email. Please try again.',

  // Register
  'register.title': 'Create account',
  'register.field.confirm_password': 'Confirm password',
  'register.error.confirm_required': 'Please confirm your password',
  'register.error.passwords_mismatch': 'Passwords do not match',
  'register.button.submit': 'Create account',
  'register.link.signin': 'Already have an account? Sign in',
  'update.title': 'Update available',
  'update.message':
      'A newer version of EmotionsMap with important improvements is available. To keep using the app you need to update it from the store.',
  'update.button': 'Update now',

  'register.email_notice.title': 'Use a real email',
  'register.email_notice.message':
      'Make sure you sign up with a real email you have access to. It will be used for critical account actions in the future, such as recovering your password.',
  'register.email_notice.button': 'Got it',

  // Journal
  'journal.title': 'My Journal',
  'journal.tooltip.search.open': 'Search',
  'journal.tooltip.search.close': 'Close search',
  'journal.tooltip.refresh': 'Refresh',
  'journal.search.hint': 'Search in comments…',
  'journal.results.one': '@count day found',
  'journal.results.other': '@count days found',
  'journal.no_results.title': 'No results',
  'journal.no_results.subtitle': 'No comments matched "@query"',
  'journal.no_results.clear': 'Clear search',
  'journal.empty.title': 'Your journal is empty',
  'journal.empty.body':
      'Add comments to your mood records to see them here as a personal journal.',
  'journal.empty.button': 'Go to grid',
  'journal.touch_hint': 'Tap to edit',
  'journal.error.load': 'Error loading journal: @e',

  // Reflections
  'reflections.title': 'Reflection Statistics',
  'reflections.tooltip.refresh': 'Refresh',
  'reflections.header.title': 'Your Reflections',
  'reflections.header.subtitle':
      'Analysis of your comments and writing habits',
  'reflections.year.tooltip.previous': 'Previous year',
  'reflections.year.tooltip.next': 'Next year',
  'reflections.summary.title': 'Summary',
  'reflections.stat.days_with_comments': 'Days with\ncomments',
  'reflections.stat.percentage': 'Of logged\ndays',
  'reflections.stat.avg_words': 'Average\nwords',
  'reflections.stat.total_days': 'Total logged\ndays',
  'reflections.streak.title': 'Writing Streaks',
  'reflections.streak.current': 'Current Streak',
  'reflections.streak.best': 'Best Streak',
  'reflections.streak.unit.one': 'day',
  'reflections.streak.unit.other': 'days',
  'reflections.streak.best_active': 'You\'re on your best streak!',
  'reflections.streak.go_for_record.one':
      'Keep going! @count day to beat your record.',
  'reflections.streak.go_for_record.other':
      'Keep going! @count days to beat your record.',
  'reflections.top_month.title': 'Most Productive Month',
  'reflections.top_month.comments.one': '@count comment',
  'reflections.top_month.comments.other': '@count comments',
  'reflections.empty.title': 'Start Reflecting',
  'reflections.empty.body':
      'Adding comments to your records helps you reflect on your emotions and discover patterns in your wellbeing.',
  'reflections.empty.tip':
      'Tap any day on the grid to add a comment about how you felt.',
  'reflections.empty.button': 'Go to grid',
  'reflections.error.load_stats': 'Error loading statistics',
  'reflections.error.load_year': 'Error loading year data',
  'reflections.error.export_image': 'Error exporting image: @e',
  'reflections.share.subject': 'EmotionsMap - My Year in Pixels @year',
  'reflections.share.text': 'My mood record for the year @year',

  // Year in pixels widget
  'year_pixels.title': 'My Year in Pixels',
  'year_pixels.tooltip.export': 'Export',
  'year_pixels.month.jan': 'Jan',
  'year_pixels.month.feb': 'Feb',
  'year_pixels.month.mar': 'Mar',
  'year_pixels.month.apr': 'Apr',
  'year_pixels.month.may': 'May',
  'year_pixels.month.jun': 'Jun',
  'year_pixels.month.jul': 'Jul',
  'year_pixels.month.aug': 'Aug',
  'year_pixels.month.sep': 'Sep',
  'year_pixels.month.oct': 'Oct',
  'year_pixels.month.nov': 'Nov',
  'year_pixels.month.dec': 'Dec',
  'year_pixels.export.title': 'My Year in Pixels @year',
  'year_pixels.export.footer': 'My mood record',

  // Word Cloud
  'wordcloud.title': 'Word Cloud',
  'wordcloud.tooltip.info': 'Information',
  'wordcloud.stat.comments': 'Comments',
  'wordcloud.stat.words': 'Words',
  'wordcloud.stat.unique': 'Unique',
  'wordcloud.legend.title': 'Color legend',
  'wordcloud.most_frequent': 'Most frequent words',
  'wordcloud.empty.title': 'Not enough data',
  'wordcloud.empty.body':
      'Add comments to your mood records to see a word cloud with the most frequent topics.',
  'wordcloud.empty.note':
      'Words must appear at least 2 times to be shown.',
  'wordcloud.empty.button': 'Back',
  'wordcloud.detail.appearances': 'Appearances',
  'wordcloud.detail.appearances_value.one': '@count time',
  'wordcloud.detail.appearances_value.other': '@count times',
  'wordcloud.detail.avg_mood': 'Average mood',
  'wordcloud.detail.avg_value': 'Average value',
  'wordcloud.detail.distribution': 'Mood distribution',
  'wordcloud.info.title': 'Word Cloud',
  'wordcloud.info.intro':
      'The word cloud shows the most frequent terms in your comments.',
  'wordcloud.info.interpretation': 'How to read it:',
  'wordcloud.info.bullets':
      '• Size: indicates word frequency.\n• Color: represents the average associated mood.\n• Tap a word to see more details.',
  'wordcloud.info.note':
      'Common words (articles, prepositions, etc.) are filtered out to show only meaningful terms.',
  'wordcloud.info.button': 'Got it',

  // Security
  'security.title': 'Security',
  'security.protection.title': 'PIN Protection',
  'security.protection.subtitle': 'Protect your emotional journal with a PIN',
  'security.toggle.title': 'Enable Security',
  'security.toggle.subtitle.on': 'Your app is protected with a PIN',
  'security.toggle.subtitle.off': 'Set up a PIN to protect your app',
  'security.change_pin.title': 'Change PIN',
  'security.change_pin.subtitle.one': '@count-digit PIN configured',
  'security.change_pin.subtitle.other': '@count-digit PIN configured',
  'security.info_banner':
      'The app will lock automatically when minimized if security is enabled.',
  'security.disable.dialog.title': 'Disable Security',
  'security.disable.dialog.message':
      'To disable security, enter your current PIN.',
  'security.error.wrong_pin': 'Wrong PIN',
  'security.error.wrong_pin_retry': 'Wrong PIN. Try again.',
  'security.error.pins_no_match': 'PINs do not match',
  'security.snack.enabled.title': 'Security Enabled',
  'security.snack.enabled.message': 'Your PIN has been set correctly',
  'security.snack.disabled.title': 'Security Disabled',
  'security.snack.disabled.message': 'Your PIN has been removed',
  'security.snack.changed.title': 'PIN Updated',
  'security.snack.changed.message': 'Your PIN has been changed correctly',
  'security.snack.enable_failed': 'Could not enable security. Please try again.',
  'security.snack.disable_failed': 'Could not disable security. Please try again.',
  'security.snack.change_failed': 'Could not change the PIN. Please try again.',
  'security.snack.wrong_old_pin': 'The current PIN is incorrect',

  // PIN Setup
  'pin_setup.title.create': 'Set up your PIN',
  'pin_setup.title.change': 'Change PIN',
  'pin_setup.title.new_create': 'Create your PIN',
  'pin_setup.title.new_change': 'New PIN',
  'pin_setup.title.confirm': 'Confirm your PIN',
  'pin_setup.subtitle.length': 'Choose your PIN length',
  'pin_setup.subtitle.old': 'Enter your current PIN',
  'pin_setup.subtitle.new': 'Enter your new PIN',
  'pin_setup.subtitle.confirm': 'Re-enter your PIN',
  'pin_setup.length.heading': 'PIN length',
  'pin_setup.length.value.one': '@count digit',
  'pin_setup.length.value.other': '@count digits',
  'pin_setup.button.continue': 'Continue',

  // Lock screen
  'lock.subtitle': 'Enter your PIN to unlock',
  'lock.forgot.button': 'Forgot your PIN?',
  'lock.forgot.confirm.title': 'Sign Out?',
  'lock.forgot.confirm.body':
      'To regain access, we will sign you out. You can sign in again and set up a new PIN.',
  'lock.forgot.confirm.signout': 'Sign Out',

  // Backup
  'backup.title': 'Data Backup',
  'backup.heading': 'Manage your data',
  'backup.subheading':
      'Export or import your mood records to keep your data safe',
  'backup.export.title': 'Export Data',
  'backup.export.subtitle':
      'Create a backup of all your records in JSON format',
  'backup.export.button': 'Export',
  'backup.import.title': 'Import Data',
  'backup.import.subtitle':
      'Restore your records from a JSON backup file',
  'backup.import.button': 'Import',
  'backup.note':
      'Backup files are in JSON format and contain all your mood records',

  // Auth errors
  'auth.signin.error.user_not_found': 'User not found',
  'auth.signin.error.wrong_password': 'Wrong password',
  'auth.signin.error.invalid_email': 'Invalid email',
  'auth.signin.error.user_disabled': 'User disabled',
  'auth.signin.error.generic': 'Sign-in failed',
  'auth.signup.error.email_in_use': 'Email is already in use',
  'auth.signup.error.invalid_email': 'Invalid email',
  'auth.signup.error.weak_password': 'Password is too weak',
  'auth.signup.error.generic': 'Sign-up failed',
  'auth.signout.error': 'Could not sign out',
  'auth.delete.error.generic': 'Could not delete account',
  'auth.delete.error.recent_login':
      'For security, please sign in again to delete your account',
  'auth.delete.success.title': 'Account Deleted',
  'auth.delete.success.message':
      'Your account has been permanently deleted',
  'auth.error.unauthenticated': 'No authenticated user',

  // Export widget footers
  'home.export.grid.footer': 'My mood record',
  'home.export.chart.footer': 'My emotional evolution',
};
