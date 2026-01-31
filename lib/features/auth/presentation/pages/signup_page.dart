import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/core/enums/user_role.dart';

/// Signup page for new users to complete their profile information.
///
/// This page is shown when a user successfully authenticates with
/// Google or Phone but doesn't exist in the system yet.
class SignupPage extends HookConsumerWidget {
  /// Creates a [SignupPage] instance.
  const SignupPage({
    super.key,
    this.email,
    this.phoneNumber,
  });

  /// Pre-filled email from Google Sign-In (optional).
  final String? email;

  /// Pre-filled phone number from Phone Auth (optional).
  final String? phoneNumber;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'signup');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome!',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please complete your profile to continue',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              _SignupForm(
                email: email,
                phoneNumber: phoneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Form widget for signup page.
class _SignupForm extends HookConsumerWidget {
  const _SignupForm({
    this.email,
    this.phoneNumber,
  });

  final String? email;
  final String? phoneNumber;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController(text: email);
    final phoneController = useTextEditingController(text: phoneNumber);
    final selectedRole = useState<UserRole>(UserRole.petOwner);
    final isLoading = useState(false);

    Future<void> handleSubmit() async {
      if (nameController.text.trim().isEmpty) {
        context.showErrorSnackBar('Please enter your name');
        return;
      }

      if (emailController.text.trim().isEmpty) {
        context.showErrorSnackBar('Please enter your email');
        return;
      }

      if (phoneController.text.trim().isEmpty) {
        context.showErrorSnackBar('Please enter your phone number');
        return;
      }

      isLoading.value = true;

      try {
        // TODO: Call API to create user account with the collected information
        // For now, just navigate to home (you'll implement the API call)
        await Future<void>.delayed(const Duration(seconds: 1)); // Simulate API call

        if (!context.mounted) return;

        // Navigate to role-specific home
        final defaultRoute = selectedRole.value.defaultRoute;
        context.goRoute(defaultRoute);
      } catch (e) {
        if (!context.mounted) return;
        context.showErrorSnackBar(e.toString());
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Name field
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.md),

        // Email field
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: email == null, // Disable if pre-filled from Google
        ),
        const SizedBox(height: AppSpacing.md),

        // Phone field
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone_outlined),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          enabled: phoneNumber == null, // Disable if pre-filled from Phone Auth
        ),
        const SizedBox(height: AppSpacing.lg),

        // Role selection
        Text(
          'Select Your Role',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        ...UserRole.values.map((final role) {
          return RadioListTile<UserRole>(
            title: Text(role.displayName),
            value: role,
            groupValue: selectedRole.value,
            onChanged: (final value) {
              if (value != null) {
                selectedRole.value = value;
              }
            },
            contentPadding: EdgeInsets.zero,
          );
        }),

        const SizedBox(height: AppSpacing.xl),

        // Submit button
        ElevatedButton(
          onPressed: isLoading.value ? null : handleSubmit,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          ),
          child: isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Complete Signup'),
        ),
      ],
    );
  }
}
