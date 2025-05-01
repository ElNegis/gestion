import 'package:flutter/material.dart';
import '../../widgets/text/TextSubTitle.dart';
import '../../widgets/botones/HelpCirle.dart';
import '../../widgets/CenteredOptionList.dart';

class PermissionModal extends StatelessWidget {
  final String title;
  final List<dynamic> permissions;
  final Function(int) onSelected;

  const PermissionModal({
    Key? key,
    required this.title,
    required this.permissions,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade400, width: 2),
      ),
      backgroundColor: const Color(0xFF2D2D3C),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextSubTitle(
                  text: title,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                const HelpCircle(
                  helpText: 'Selecciona una opción de la lista para asignar/eliminar permisos.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            CenteredOptionList(
              options: permissions,
              onSelected: onSelected,
            ),
          ],
        ),
      ),
    );
  }
}
