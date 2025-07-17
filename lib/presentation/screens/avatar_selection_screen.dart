import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../../core/utils/service_locator.dart';

// Importe o arquivo de localizações gerado
import '../../l10n/generated/app_localizations.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  List<String> _avatarUrls = [];
  String? _selectedAvatar;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadAvatars();
  }

  Future<void> _loadAvatars() async {
    try {
      final avatarRepository = ServiceLocator.avatarRepository;
      final avatars = await avatarRepository.getAvatarOptions();
      setState(() {
        _avatarUrls = avatars;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        // Use a string de localização para a mensagem de erro
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failed_to_load_avatars),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
    }
  }

  Future<void> _selectAvatar(String avatarUrl) async {
    setState(() {
      _selectedAvatar = avatarUrl;
    });
  }

  Future<void> _continueWithAvatar() async {
    if (_selectedAvatar == null) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateAvatar(_selectedAvatar!);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        // Use a string de localização para a mensagem de erro
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failed_to_update_avatar),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
    } finally {
      if(mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _skipAvatarSelection() async {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    // Obtenha a instância de AppLocalizations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          l10n.title_choose_avatar, // Substituído
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _skipAvatarSelection,
            child: Text(
              l10n.button_skip, // Substituído
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              l10n.title_choose_avatar, // Substituído
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE53E3E),
                ),
              )
                  : _avatarUrls.isEmpty
                  ? Center(
                child: Text(
                  l10n.no_avatars_available, // Substituído
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: _avatarUrls.length,
                  itemBuilder: (context, index) {
                    final avatarUrl = _avatarUrls[index];
                    final isSelected = _selectedAvatar == avatarUrl;

                    return GestureDetector(
                      onTap: () => _selectAvatar(avatarUrl),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE53E3E)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF2D2D2D),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFE53E3E),
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF2D2D2D),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedAvatar != null && !_isUpdating
                      ? _continueWithAvatar
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53E3E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isUpdating
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    l10n.button_continue, // Substituído
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}