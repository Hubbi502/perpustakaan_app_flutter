import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/core/errors/exceptions.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:library_app/core/utils/validators.dart';
import 'package:library_app/core/widgets/app_button.dart';
import 'package:library_app/core/widgets/app_snackbar.dart';
import 'package:library_app/core/widgets/app_text_field.dart';
import 'package:library_app/domain/entities/book.dart';
import 'package:library_app/presentation/petugas/providers/book_management_provider.dart';
import 'package:library_app/presentation/petugas/providers/category_management_provider.dart';
import 'package:provider/provider.dart';

/// Book add/edit form screen with image picker.
class BookFormScreen extends StatefulWidget {
  final Book? book; // null for create, non-null for edit

  const BookFormScreen({super.key, this.book});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedCategoryId;
  File? _coverImage;
  bool get isEditing => widget.book != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _descriptionController.text = widget.book!.description ?? '';
      _selectedCategoryId = widget.book!.categoryId ?? widget.book!.category?.id;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryManagementProvider>().fetchCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024, imageQuality: 85);
    if (picked != null) {
      setState(() => _coverImage = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategoryId == null) {
      AppSnackbar.warning(context, 'Pilih kategori buku');
      return;
    }

    final provider = context.read<BookManagementProvider>();

    try {
      if (isEditing) {
        await provider.updateBook(
          widget.book!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          author: _authorController.text.trim(),
          categoryId: _selectedCategoryId,
          coverImage: _coverImage,
        );
        if (mounted) AppSnackbar.success(context, 'Buku berhasil diperbarui');
      } else {
        await provider.createBook(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          author: _authorController.text.trim(),
          categoryId: _selectedCategoryId!,
          coverImage: _coverImage,
        );
        if (mounted) AppSnackbar.success(context, 'Buku berhasil ditambahkan');
      }
      if (mounted) Navigator.pop(context);
    } on ValidationException catch (e) {
      if (mounted) AppSnackbar.error(context, e.firstError);
    } on AppException catch (e) {
      if (mounted) AppSnackbar.error(context, e.message);
    } catch (e) {
      if (mounted) AppSnackbar.error(context, 'Terjadi kesalahan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final catProvider = context.watch<CategoryManagementProvider>();
    final bookProvider = context.watch<BookManagementProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Text(isEditing ? 'Edit Buku' : 'Tambah Buku', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 160,
                    height: 220,
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glassBorder),
                      image: _coverImage != null
                          ? DecorationImage(image: FileImage(_coverImage!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _coverImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate_rounded, size: 40, color: AppColors.textTertiary),
                              const SizedBox(height: 8),
                              Text('Pilih Cover', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                            ],
                          )
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              AppTextField(
                controller: _titleController,
                label: 'Judul Buku',
                hint: 'Masukkan judul buku',
                prefixIcon: Icons.title_rounded,
                validator: (v) => Validators.required(v, 'Judul'),
              ),

              const SizedBox(height: 18),

              AppTextField(
                controller: _authorController,
                label: 'Penulis',
                hint: 'Masukkan nama penulis',
                prefixIcon: Icons.person_outline_rounded,
                validator: (v) => Validators.required(v, 'Penulis'),
              ),

              const SizedBox(height: 18),

              // Category dropdown
              Text(
                'Kategori',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                dropdownColor: AppColors.surfaceDark,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                hint: Text('Pilih kategori', style: GoogleFonts.inter(color: AppColors.textTertiary)),
                items: catProvider.categories.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
              ),

              const SizedBox(height: 18),

              AppTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
                hint: 'Masukkan deskripsi buku',
                prefixIcon: Icons.description_rounded,
                maxLines: 4,
                validator: (v) => Validators.required(v, 'Deskripsi'),
              ),

              const SizedBox(height: 32),

              AppButton(
                text: isEditing ? 'Simpan Perubahan' : 'Tambah Buku',
                icon: isEditing ? Icons.save_rounded : Icons.add_rounded,
                onPressed: _save,
                isLoading: bookProvider.isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
