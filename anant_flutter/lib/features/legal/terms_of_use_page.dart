import 'package:anant_flutter/config/role_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Terms of Use'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Terms of Use'),
            const SizedBox(height: 8),
            _buildLastUpdated('Last Updated: December 23, 2024'),
            const SizedBox(height: 24),
            
            _buildIntroduction(),
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using the Anant School Management System ("the App"), you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use the App.',
            ),
            
            _buildSection(
              '2. User Accounts',
              'To access certain features of the App, you may be required to create an account. You are responsible for:\n\n'
              '• Maintaining the confidentiality of your account credentials\n'
              '• All activities that occur under your account\n'
              '• Notifying us immediately of any unauthorized use\n'
              '• Ensuring your account information is accurate and up-to-date',
            ),
            
            _buildSection(
              '3. User Roles and Access',
              'The App provides different access levels based on user roles:\n\n'
              '• Students: Access to personal academic information, attendance, fees, and announcements\n'
              '• Teachers: Access to class management, student information, and attendance marking\n'
              '• Parents: Access to their children\'s academic information and fee payments\n'
              '• Administrators: Full access to system management and configuration\n\n'
              'Users must only access information relevant to their assigned role.',
            ),
            
            _buildSection(
              '4. Acceptable Use',
              'You agree to use the App only for lawful purposes. You must not:\n\n'
              '• Use the App to violate any laws or regulations\n'
              '• Share your login credentials with others\n'
              '• Attempt to gain unauthorized access to any portion of the App\n'
              '• Upload or transmit viruses or malicious code\n'
              '• Harass, abuse, or harm other users\n'
              '• Use the App for commercial purposes without authorization\n'
              '• Scrape, copy, or download data without permission',
            ),
            
            _buildSection(
              '5. Data Privacy and Protection',
              'We take your privacy seriously. Your personal information is handled in accordance with our Privacy Policy. By using the App:\n\n'
              '• You consent to the collection and use of your information as described in our Privacy Policy\n'
              '• You understand that educational institutions may access your academic records\n'
              '• You agree to provide accurate and truthful information',
            ),
            
            _buildSection(
              '6. Intellectual Property',
              'All content, features, and functionality of the App, including but not limited to:\n\n'
              '• Software, code, and algorithms\n'
              '• Text, graphics, logos, and images\n'
              '• Design and layout\n\n'
              'are owned by Anant or its licensors and are protected by intellectual property laws. You may not reproduce, distribute, or create derivative works without explicit permission.',
            ),
            
            _buildSection(
              '7. Fee Payments',
              'For fee payment features:\n\n'
              '• You are responsible for ensuring timely payment of fees\n'
              '• Payment information must be accurate\n'
              '• The institution reserves the right to charge late fees as per policy\n'
              '• Refund policies are governed by the educational institution\'s policies',
            ),
            
            _buildSection(
              '8. Attendance and Academic Records',
              'Attendance and academic information displayed in the App:\n\n'
              '• Is provided for informational purposes\n'
              '• May be subject to verification and correction\n'
              '• Should be reported to the institution if discrepancies are found\n'
              '• Is the official record maintained by the educational institution',
            ),
            
            _buildSection(
              '9. Notifications and Communications',
              'By using the App, you agree to receive:\n\n'
              '• Important announcements from the institution\n'
              '• Notifications about attendance, fees, and academic updates\n'
              '• System updates and maintenance notices\n\n'
              'You can manage notification preferences in your account settings.',
            ),
            
            _buildSection(
              '10. Limitation of Liability',
              'To the maximum extent permitted by law:\n\n'
              '• The App is provided "as is" without warranties of any kind\n'
              '• We are not liable for any indirect, incidental, or consequential damages\n'
              '• We do not guarantee uninterrupted or error-free operation\n'
              '• Total liability is limited to the amount paid for App access (if any)',
            ),
            
            _buildSection(
              '11. Service Modifications',
              'We reserve the right to:\n\n'
              '• Modify, suspend, or discontinue any part of the App\n'
              '• Update these Terms of Use at any time\n'
              '• Change features, pricing, or access requirements\n\n'
              'Continued use after changes constitutes acceptance of new terms.',
            ),
            
            _buildSection(
              '12. Account Termination',
              'We may terminate or suspend your account if:\n\n'
              '• You violate these Terms of Use\n'
              '• Your enrollment or employment with the institution ends\n'
              '• Required by law or regulatory authorities\n'
              '• At the institution\'s discretion for operational reasons',
            ),
            
            _buildSection(
              '13. Governing Law',
              'These Terms shall be governed by and construed in accordance with the laws of India, without regard to its conflict of law provisions.',
            ),
            
            _buildSection(
              '14. Contact Information',
              'For questions about these Terms of Use, please contact:\n\n'
              'Email: support@anantschool.edu\n'
              'Address: [Your Institution Address]\n'
              'Phone: [Contact Number]',
            ),
            
            const SizedBox(height: 32),
            
            _buildFooter(context),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3142),
      ),
    );
  }

  Widget _buildLastUpdated(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
              const SizedBox(width: 12),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to Anant School Management System. These Terms of Use govern your access to and use of our platform. Please read them carefully.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.verified_user,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 12),
          const Text(
            'Thank you for using Anant',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'By continuing to use our services, you acknowledge that you have read and agree to these Terms of Use.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
