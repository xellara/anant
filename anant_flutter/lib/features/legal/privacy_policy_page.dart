import 'package:anant_flutter/config/role_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Privacy Policy'),
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
            _buildHeader('Privacy Policy'),
            const SizedBox(height: 8),
            _buildLastUpdated('Last Updated: December 23, 2024'),
            const SizedBox(height: 24),
            
            _buildIntroduction(),
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Information We Collect',
              'We collect various types of information to provide and improve our services:\n\n'
              '**Personal Information:**\n'
              '• Name, date of birth, and gender\n'
              '• Contact details (email, phone number, address)\n'
              '• Photographs and identification documents\n'
              '• Aadhaar number (where applicable)\n'
              '• Parent/guardian information\n\n'
              '**Academic Information:**\n'
              '• Student enrollment details\n'
              '• Class, section, and roll numbers\n'
              '• Attendance records\n'
              '• Academic performance and grades\n'
              '• Assignment and examination records\n\n'
              '**Financial Information:**\n'
              '• Fee payment history\n'
              '• Transaction records\n'
              '• Payment method details (processed securely)\n\n'
              '**Technical Information:**\n'
              '• Device information and IP address\n'
              '• App usage data and analytics\n'
              '• Login timestamps and session data',
            ),
            
            _buildSection(
              '2. How We Use Your Information',
              'We use collected information for the following purposes:\n\n'
              '**Educational Services:**\n'
              '• Managing student enrollment and records\n'
              '• Tracking attendance and academic progress\n'
              '• Communicating academic updates and announcements\n'
              '• Generating report cards and certificates\n\n'
              '**Administrative Operations:**\n'
              '• Processing fee payments\n'
              '• Managing user accounts and access\n'
              '• Coordinating between teachers, students, and parents\n'
              '• Maintaining institutional records\n\n'
              '**Communication:**\n'
              '• Sending notifications about attendance, fees, and events\n'
              '• Sharing important announcements\n'
              '• Responding to inquiries and support requests\n\n'
              '**Security and Compliance:**\n'
              '• Protecting against unauthorized access\n'
              '• Complying with legal and regulatory requirements\n'
              '• Investigating violations of terms of use',
            ),
            
            _buildSection(
              '3. Data Sharing and Disclosure',
              'We may share your information in the following circumstances:\n\n'
              '**Within the Institution:**\n'
              '• Teachers and staff with legitimate educational interests\n'
              '• Administrative personnel for operational purposes\n'
              '• School management for oversight and decision-making\n\n'
              '**With Parents/Guardians:**\n'
              '• Academic performance and attendance\n'
              '• Fee-related information\n'
              '• Announcements and important notices\n\n'
              '**Third-Party Service Providers:**\n'
              '• Payment processors (for fee transactions)\n'
              '• Cloud hosting services (for data storage)\n'
              '• Communication services (for notifications)\n\n'
              '**Legal Requirements:**\n'
              '• When required by law or legal process\n'
              '• To protect rights, property, or safety\n'
              '• In response to government requests\n\n'
              '**We do NOT:**\n'
              '• Sell your personal information to third parties\n'
              '• Share data for marketing purposes without consent\n'
              '• Disclose sensitive information unnecessarily',
            ),
            
            _buildSection(
              '4. Data Security',
              'We implement appropriate security measures to protect your information:\n\n'
              '**Technical Safeguards:**\n'
              '• Encryption of data in transit and at rest\n'
              '• Secure authentication mechanisms\n'
              '• Regular security audits and updates\n'
              '• Firewall and intrusion detection systems\n\n'
              '**Administrative Controls:**\n'
              '• Role-based access control\n'
              '• Employee training on data protection\n'
              '• Regular security policy reviews\n'
              '• Incident response procedures\n\n'
              '**Physical Security:**\n'
              '• Secure data center facilities\n'
              '• Restricted access to servers\n'
              '• Regular backup and disaster recovery plans\n\n'
              'However, no method of transmission over the internet is 100% secure. We cannot guarantee absolute security.',
            ),
            
            _buildSection(
              '5. Data Retention',
              'We retain your information for as long as necessary:\n\n'
              '• **Active Students/Staff:** Throughout enrollment/employment period\n'
              '• **Academic Records:** As per educational regulations (typically 7-10 years)\n'
              '• **Financial Records:** As per tax and accounting requirements\n'
              '• **Personal Data:** Until account deletion or opt-out request\n\n'
              'You may request deletion of your data, subject to legal and institutional requirements.',
            ),
            
            _buildSection(
              '6. Your Rights and Choices',
              'You have the following rights regarding your personal information:\n\n'
              '**Access and Correction:**\n'
              '• View your personal information in the app\n'
              '• Request corrections to inaccurate data\n'
              '• Update your profile and contact details\n\n'
              '**Data Portability:**\n'
              '• Request a copy of your data in a portable format\n'
              '• Transfer data to another institution (where applicable)\n\n'
              '**Deletion:**\n'
              '• Request deletion of your account and personal data\n'
              '• Note: Some data may be retained for legal compliance\n\n'
              '**Opt-Out:**\n'
              '• Disable non-essential notifications\n'
              '• Manage communication preferences\n'
              '• Withdraw consent for optional data processing\n\n'
              'To exercise these rights, contact: privacy@anantschool.edu',
            ),
            
            _buildSection(
              '7. Children\'s Privacy',
              'Our App is designed for educational purposes and may be used by minors:\n\n'
              '• We collect only necessary information for educational purposes\n'
              '• Parents/guardians have the right to review their child\'s data\n'
              '• We do not knowingly collect information from children under 13 without parental consent\n'
              '• Special protections apply to student data per educational privacy laws',
            ),
            
            _buildSection(
              '8. Cookies and Tracking',
              'We use cookies and similar technologies:\n\n'
              '**Essential Cookies:**\n'
              '• Authentication and session management\n'
              '• Security and fraud prevention\n\n'
              '**Analytics:**\n'
              '• App usage statistics\n'
              '• Performance monitoring\n'
              '• User experience improvements\n\n'
              'You can manage cookie preferences in your device settings.',
            ),
            
            _buildSection(
              '9. Third-Party Links',
              'Our App may contain links to third-party websites or services:\n\n'
              '• We are not responsible for their privacy practices\n'
              '• We recommend reviewing their privacy policies\n'
              '• Exercise caution when sharing information on external sites',
            ),
            
            _buildSection(
              '10. International Data Transfers',
              'Your information may be transferred to and stored in:\n\n'
              '• Servers located in India or other countries\n'
              '• Cloud infrastructure with international presence\n\n'
              'We ensure appropriate safeguards are in place for such transfers.',
            ),
            
            _buildSection(
              '11. Changes to Privacy Policy',
              'We may update this Privacy Policy from time to time:\n\n'
              '• Changes will be posted on this page\n'
              '• Significant changes will be notified via email or app notification\n'
              '• Continued use after changes constitutes acceptance\n'
              '• Previous versions available upon request',
            ),
            
            _buildSection(
              '12. Data Breach Notification',
              'In the event of a data breach:\n\n'
              '• We will notify affected users promptly\n'
              '• Regulatory authorities will be informed as required\n'
              '• Steps to mitigate harm will be communicated\n'
              '• Investigation and remediation will be conducted',
            ),
            
            _buildSection(
              '13. Contact Us',
              'For privacy-related questions or concerns:\n\n'
              '**Data Protection Officer:**\n'
              'Email: privacy@anantschool.edu\n'
              'Phone: [Contact Number]\n'
              'Address: [Your Institution Address]\n\n'
              '**General Inquiries:**\n'
              'Email: support@anantschool.edu\n\n'
              'We will respond to your request within 30 days.',
            ),
            
            _buildSection(
              '14. Compliance',
              'We comply with applicable data protection laws including:\n\n'
              '• Information Technology Act, 2000 (India)\n'
              '• Personal Data Protection Bill (when enacted)\n'
              '• Educational privacy regulations\n'
              '• Industry best practices and standards',
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
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: Colors.green[700], size: 24),
              const SizedBox(width: 12),
              const Text(
                'Your Privacy Matters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This Privacy Policy explains how Anant School Management System collects, uses, and protects your personal information. We are committed to maintaining the privacy and security of your data.',
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
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 40,
            color: Colors.green[700],
          ),
          const SizedBox(height: 12),
          const Text(
            'We Protect Your Privacy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your trust is important to us. We are committed to protecting your personal information and using it responsibly.',
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
