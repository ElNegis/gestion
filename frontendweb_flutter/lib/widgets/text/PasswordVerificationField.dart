import 'package:flutter/material.dart';
import '../LabelAboveWidget.dart';
import 'type_text_enum.dart';

class PasswordVerificationField extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final double? width;
  final double height;
  final bool isDoubleField;

  // Personalización adicional
  final String hintText;
  final String? confirmHintText;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? hintStyle;
  final Icon? prefixIcon;
  final TypeText validationType;

  const PasswordVerificationField({
    Key? key,
    required this.passwordController,
    this.confirmPasswordController,
    this.width = 550.0,
    this.height = 50.0,
    this.isDoubleField = false,
    this.hintText = "Ingresa la contraseña",
    this.confirmHintText,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintStyle,
    this.prefixIcon,
    this.validationType = TypeText.none,
  }) : super(key: key);

  @override
  _PasswordVerificationFieldState createState() =>
      _PasswordVerificationFieldState();
}

class _PasswordVerificationFieldState extends State<PasswordVerificationField> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  double _strengthLevel = 0.0;
  String _strengthLabel = "";
  Color _strengthColor = Colors.red;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_validateMatch);
    widget.confirmPasswordController?.addListener(_validateMatch);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_validateMatch);
    widget.confirmPasswordController?.removeListener(_validateMatch);
    super.dispose();
  }

  /// Validar la fortaleza de la contraseña
  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _strengthLevel = 0.0;
        _strengthLabel = "Ingresa una contraseña";
        _strengthColor = Colors.red;
        return;
      }

      // Reglas de validación
      bool hasLength = password.length >= 12;
      bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
      bool hasNumbers = password.contains(RegExp(r'\d'));
      bool hasSpecialChars = password.contains(RegExp(r'[!@#\$&*~]'));
      bool hasCommonPatterns = password.contains(
        RegExp(
          r'(password|1234|admin|qwerty|abcd|1111|aaaa|0000|letmein|welcome)',
          caseSensitive: false,
        ),
      );

      bool hasRepetitions = password.contains(RegExp(r'(.)\1{2,}')); // 3+ repeticiones

      // Evaluar fortaleza
      int score = 0;
      if (hasLength) score++;
      if (hasUpperCase) score++;
      if (hasLowerCase) score++;
      if (hasNumbers) score++;
      if (hasSpecialChars) score++;

      // Penalizaciones por patrones débiles
      if (hasCommonPatterns || hasRepetitions) {
        _strengthLevel = 0.4;
        _strengthLabel = "Evita patrones comunes y repeticiones";
        _strengthColor = Colors.orange;
        return;
      }

      // Fortaleza basada en el puntaje
      switch (score) {
        case 5:
          _strengthLevel = 1.0;
          _strengthLabel = "Fortaleza: Muy fuerte";
          _strengthColor = Colors.green;
          break;
        case 4:
          _strengthLevel = 0.8;
          _strengthLabel = "Fortaleza: Fuerte";
          _strengthColor = Colors.lightGreen;
          break;
        case 3:
          _strengthLevel = 0.6;
          _strengthLabel = "Fortaleza: Moderada";
          _strengthColor = Colors.yellow;
          break;
        case 2:
          _strengthLevel = 0.4;
          _strengthLabel = "Fortaleza: Débil";
          _strengthColor = Colors.orange;
          break;
        default:
          _strengthLevel = 0.2;
          _strengthLabel = "Muy débil";
          _strengthColor = Colors.red;
      }
    });
  }

  /// Validar si las contraseñas coinciden
  void _validateMatch() {
    if (widget.isDoubleField && widget.confirmPasswordController != null) {
      setState(() {
        if (widget.passwordController.text !=
            widget.confirmPasswordController!.text) {
          _errorMessage = "Las contraseñas no coinciden";
        } else {
          _errorMessage = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de contraseña principa
          _buildPasswordField(
            controller: widget.passwordController,
            hintText: widget.hintText,
            isPasswordVisible: _isPasswordVisible,
            onVisibilityToggle: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            onChanged: _validatePassword,
          ),

        const SizedBox(height: 8),
        Container(
          width: widget.width,
          height: 5.0, // Barra de progreso
          child: LinearProgressIndicator(
            value: _strengthLevel,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(_strengthColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _strengthLabel,
          style: TextStyle(color: _strengthColor),
        ),
        const SizedBox(height: 16),

        if (widget.isDoubleField) ...[
          LabelAboveWidget(
            label: "Confirmar Contraseña",
            child: _buildPasswordField(
              controller: widget.confirmPasswordController!,
              hintText: widget.confirmHintText ?? "Confirma la contraseña",
              isPasswordVisible: _isConfirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          if (_errorMessage != null)
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityToggle,
    Function(String)? onChanged,
  }) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: widget.borderColor ?? Colors.grey[600]!,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: widget.prefixIcon,
            ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !isPasswordVisible,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: widget.hintStyle ??
                    const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                border: InputBorder.none,
              ),
              style: TextStyle(color: widget.textColor ?? Colors.black),
            ),
          ),
          GestureDetector(
            onTap: onVisibilityToggle,
            child: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
