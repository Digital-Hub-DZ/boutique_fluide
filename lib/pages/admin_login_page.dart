import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:boutique_fluide/services/admin_auth_service.dart';
import 'package:boutique_fluide/theme.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: AdminAuthService.defaultAdminEmail);
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = context.read<AdminAuthService>();
      final error = await auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (error != null) {
        setState(() => _error = error);
        return;
      }

      final from = GoRouterState.of(context).uri.queryParameters['from'];
      context.go(from ?? '/admin');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Espace staff', style: theme.textTheme.displaySmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Accès réservé au personnel pour gérer les produits et le stock.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.charcoal),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.midnight.withValues(alpha: 0.06),
                          blurRadius: 22,
                          offset: const Offset(0, 14),
                        ),
                      ],
                      border: Border.all(color: AppColors.charcoal.withValues(alpha: 0.08)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Connexion', style: theme.textTheme.titleLarge),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Adresse e-mail'),
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'Veuillez saisir un e-mail.';
                              if (!value.contains('@')) return 'E-mail invalide.';
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() => _obscure = !_obscure),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  child: Icon(
                                    _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                              ),
                            ),
                            validator: (v) {
                              if ((v ?? '').isEmpty) return 'Veuillez saisir un mot de passe.';
                              return null;
                            },
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                                border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
                              ),
                              child: Text(_error!, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error)),
                            ),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: _isLoading
                                    ? const SizedBox(
                                        key: ValueKey('loading'),
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.pureWhite),
                                      )
                                    : const Text('Se connecter', key: ValueKey('text')),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Démo: e-mail prérempli. Mot de passe: Admin123!',
                            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.charcoal),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Text(
                      'Retour à la boutique',
                      style: theme.textTheme.titleSmall?.copyWith(color: AppColors.midnight),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
