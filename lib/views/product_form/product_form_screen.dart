import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  bool _isSaving = false;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    _priceCtrl = TextEditingController(
      text: widget.product != null
          ? widget.product!.price.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);

    final price = double.parse(_priceCtrl.text.trim());
    final product = Product(
      id: widget.product?.id,
      name: _nameCtrl.text.trim(),
      price: price,
    );

    final provider = context.read<ProductProvider>();
    try {
      if (_isEditing) {
        await provider.updateProduct(product);
      } else {
        await provider.addProduct(product);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Product updated' : 'Product added'),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primary,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CATALOG MANAGEMENT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isEditing ? 'Modify Product' : 'Define New Product',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 3,
                  width: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                _FormCard(
                  isEditing: _isEditing,
                  nameCtrl: _nameCtrl,
                  priceCtrl: _priceCtrl,
                  isSaving: _isSaving,
                  onSave: _save,
                  onCancel: () => Navigator.of(context).maybePop(),
                ),
                if (_isEditing) ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 222, 222, 227),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            size: 18, color: AppColors.textSecondary),
                        SizedBox(width: 10),
                        Expanded(
                
                          child: Text(
                            'Updating product details will synchronize changes across all active inventory dashboards and analytics reports instantly.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameCtrl;
  final TextEditingController priceCtrl;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _FormCard({
    required this.isEditing,
    required this.nameCtrl,
    required this.priceCtrl,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(text: isEditing ? 'PRODUCT NAME' : 'Product Name'),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              hintText: 'e.g. Enterprise Cloud Module',
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Product name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _FieldLabel(text: isEditing ? 'PRICE' : 'Price'),
          const SizedBox(height: 8),
          TextFormField(
            controller: priceCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: const InputDecoration(
              prefixText: '\$ ',
              hintText: '0.00',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Price is required';
              }
              final parsed = double.tryParse(value.trim());
              if (parsed == null) return 'Enter a valid number';
              if (parsed < 0) return 'Price cannot be negative';
              return null;
            },
          ),
          if (!isEditing) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 232, 229, 229),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: Color.fromARGB(255, 23, 71, 175)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ensure product pricing aligns with current regional tax regulations and platform fees.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color.fromARGB(255, 22, 22, 23),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.5),
                disabledForegroundColor: Colors.white70,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(isEditing ? 'Save Changes' : 'Save Product'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isSaving ? null : onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final isUpper = text == text.toUpperCase();
    return Text(
      text,
      style: TextStyle(
        fontSize: isUpper ? 11 : 13,
        fontWeight: FontWeight.w700,
        color: isUpper ? AppColors.primary : AppColors.textPrimary,
        letterSpacing: isUpper ? 0.8 : 0,
      ),
    );
  }
}
