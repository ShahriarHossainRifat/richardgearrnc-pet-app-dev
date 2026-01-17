import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Login page for user authentication.
class LoginPage extends ConsumerStatefulWidget {
  /// Creates a [LoginPage] instance.
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Track screen view once on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'login');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    ref
        .read(authProvider)
        .whenOrNull(
          error: (final error, _) {
            context.showErrorSnackBar(error.toString());
          },
          data: (final user) {
            if (user != null) {
              context.goRoute(AppRoute.home);
            }
          },
        );
  }

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusXXL,
                        ),
                      ),
                      child: Icon(
                        Icons.flutter_dash,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    // Title
                    Text(
                      l10n.welcomeBack,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace.sm(),
                    Text(
                      l10n.signInToContinue,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace.xl(),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: Validators.compose([
                        Validators.required(l10n.emailRequired),
                        Validators.email(l10n.emailInvalid),
                      ]),
                    ),
                    const VerticalSpace.md(),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _handleLogin(),
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: Validators.compose([
                        Validators.required(l10n.passwordRequired),
                        Validators.strongPassword(l10n.passwordWeak),
                      ]),
                    ),
                    const VerticalSpace.lg(),

                    // Login button
                    AppButton(
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                      isExpanded: true,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _handleLogin,
                      label: l10n.login,
                    ),
                    const VerticalSpace.md(),

                    // Forgot password
                    AppButton(
                      variant: AppButtonVariant.text,
                      size: AppButtonSize.medium,
                      isExpanded: true,
                      onPressed: isLoading
                          ? null
                          : () {
                              // TODO: Navigate to forgot password
                            },
                      label: l10n.forgotPassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
