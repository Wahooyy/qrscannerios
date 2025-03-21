import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:hugeicons/hugeicons.dart';


class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  
  MobileScannerController cameraController = MobileScannerController();
  bool _hasPermission = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  final TextEditingController _salesOrderController = TextEditingController();
  final TextEditingController _debugProductController = TextEditingController(); 
  final Set<String> _scannedProducts = {};
  String? _currentSalesOrder;
  bool _showDebugInput = false; 
  
  String? _selectedPrefix;
  
  final Map<String, List<String>> _dummyData = {
    'SO': ['SO01', 'SO02', 'SO03'],
    'PO': ['PO01', 'PO02', 'PO03', 'PO04'],
    'PD': ['PD01', 'PD02', 'PD03', 'PD04', 'PD05']
  };
  
  final List<String> _dummyProducts = [
    'KD01',
    'KD02',
    'KD03',
    'KD04',
    'KD05',
    'KD06',
    'KD07',
    'KD08',
    'KD09',
    'KD10',
    'KD11',
    'KD12',
    'KD13',
    'KD14',
    'KD15',
    'KD16',
    'KD17',
    'KD18',
    'KD19',
    'KD20',
  ];

  @override
  void initState() {
    super.initState();
    _checkPermission();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 200.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    _salesOrderController.dispose();
    _debugProductController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7E4E4),
              borderRadius: SmoothBorderRadius(
                cornerRadius: 8,
                cornerSmoothing: 1,
              ),
              border: Border.all(color: const Color(0xFFFFA3A6)),
            ),
            child: Row(
              children: [
                const Icon(
                  HugeIcons.strokeRoundedAlertCircle,
                  color: Color(0xFFE21C3D),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF141414),
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    HugeIcons.strokeRoundedMultiplicationSign,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => overlayEntry.remove(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }


  Future<void> _checkPermission() async {
    try {
      final status = await Permission.camera.status;
      
      if (status.isDenied) {
        final result = await Permission.camera.request();
        setState(() {
          _hasPermission = result.isGranted;
        });
      } else if (status.isPermanentlyDenied) {
        setState(() {
          _hasPermission = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Camera Permission Required'),
            content: const Text(
              'Camera permission is required to scan QR codes. Please enable it in Settings.',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _hasPermission = status.isGranted;
        });
      }
    } catch (e) {
      print('Error checking camera permission: $e');
      setState(() {
        _hasPermission = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedBug01),
            onPressed: () {
              setState(() {
                _showDebugInput = !_showDebugInput;
              });
            },
          ),
          IconButton(
            icon: ValueListenableBuilder<TorchState>(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                return Icon(
                  state == TorchState.off 
                    ? HugeIcons.strokeRoundedFlashOff 
                    : HugeIcons.strokeRoundedFlash,
                  color: Colors.black,
                  size: 24,
                );
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [ 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _salesOrderController,
                        decoration: InputDecoration(
                          hintText: _selectedPrefix == null 
                            ? 'Pilih tipe pencarian dulu' 
                            : 'Cari Kode ${_selectedPrefix}',
                          filled: true,
                          fillColor: Colors.white, 
                          border: OutlineInputBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 12,
                              cornerSmoothing: 1,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: IconButton(
                            icon: Icon(HugeIcons.strokeRoundedSearch01),
                            onPressed: () {
                              _searchWithPrefix();
                            },
                          ),
                          prefixText: _selectedPrefix != null ? '${_selectedPrefix!} ' : null,
                          prefixStyle: GoogleFonts.outfit(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          enabled: _selectedPrefix != null,
                        ),
                        onSubmitted: (value) {
                          _searchWithPrefix();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(HugeIcons.strokeRoundedFilterHorizontal),
                        onPressed: () {
                          _showFilterOptions(context);
                        },
                      ),
                    ),
                  ],
                ),
                if (_selectedPrefix == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 8,
                          cornerSmoothing: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.amber),
                          const SizedBox(width: 8),
                          const Text('Pilih SO, PO, atau PD terlebih dahulu'),
                        ],
                      ),
                    ),
                  ),
                if (_showDebugInput && _currentSalesOrder != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 8,
                              cornerSmoothing: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.bug_report, color: Colors.amber),
                              const SizedBox(width: 8),
                              const Text('Debug Mode: Tambah Manual'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _debugProductController,
                                decoration: InputDecoration(
                                  hintText: 'Kode Roll',
                                  filled: true,
                                  fillColor: Colors.white, 
                                  border: OutlineInputBorder(
                                    borderRadius: SmoothBorderRadius(
                                      cornerRadius: 12,
                                      cornerSmoothing: 1,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_debugProductController.text.isNotEmpty) {
                                  _addScannedProduct(_debugProductController.text);
                                  _debugProductController.clear();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 12,
                                    cornerSmoothing: 1,
                                  ),
                                ),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          if (_currentSalesOrder != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color(0xFF3461FD).withOpacity(0.1),
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 8,
                    cornerSmoothing: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF3461FD)),
                    const SizedBox(width: 8),
                    Text(
                      'Scan untuk $_selectedPrefix: $_currentSalesOrder',
                      style: GoogleFonts.outfit(
                        color: Color(0xFF3461FD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_hasPermission && _currentSalesOrder != null && !_showDebugInput)
            Container(
              margin: const EdgeInsets.all(16),
              height: 250,
              width: double.infinity, 
              decoration: BoxDecoration(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 12,
                  cornerSmoothing: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 12,
                  cornerSmoothing: 1,
                ),
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final code = barcode.rawValue ?? 'QR Code tidak ditemukan';
                          _addScannedProduct(code);
                        }
                      },
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 12,
                            cornerSmoothing: 1,
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: _animation.value,
                          left: 100,
                          right: 100, 
                          child: Container(
                            width: 200,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          
          if (_currentSalesOrder != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      'List Item',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _scannedProducts.length,
                    itemBuilder: (context, index) {
                      final code = _scannedProducts.elementAt(index);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16), 
                        child: ClipRRect(
                          borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 1,
                        ),
                          child: Dismissible(
                            key: Key(code),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                _scannedProducts.remove(code);
                              });
                              _showSnackBar(context, '$code dihapus');
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFF3461FD).withOpacity(0.3),
                              ),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    HugeIcons.strokeRoundedDelete02,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Text(
                                code,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  _selectedPrefix == null 
                    ? 'Pilih tipe pencarian (SO, PO, PD) terlebih dahulu' 
                    : 'Masukkan kode $_selectedPrefix terlebih dahulu',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), 
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 1,
                        ),
                ),
              ),
              onPressed: (_currentSalesOrder != null && _scannedProducts.isNotEmpty) 
                ? () {
                    _showSnackBar(context, 'Berhasil!');
                  }
                : null,
              child: Text(
                'Simpan',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Tipe Pencarian',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFilterOption('SO', setModalState),
                _buildFilterOption('PO', setModalState),
                _buildFilterOption('PD', setModalState),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 1,
                        ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _salesOrderController.clear();
                    setState(() {
                      _currentSalesOrder = null;
                      _scannedProducts.clear();
                    });
                  },
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildFilterOption(String label, StateSetter setModalState) {
    return InkWell(
      onTap: () {
        setModalState(() {
          setState(() {
            _selectedPrefix = label;
          });
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: _selectedPrefix == label ? Color(0xFF3461FD).withOpacity(0.1) : Colors.white,
          borderRadius: _selectedPrefix == label 
            ? SmoothBorderRadius(
                cornerRadius: 8,
                cornerSmoothing: 1,
              )
            : BorderRadius.zero,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _selectedPrefix == label ? Color(0xFF3461FD) : Colors.black,
              ),
            ),
            const Spacer(),
            if (_selectedPrefix == label)
              Icon(Icons.check_circle, color: Color(0xFF3461FD)),
          ],
        ),
      ),
    );
  }

  void _searchWithPrefix() {
    if (_selectedPrefix == null) {
      _showSnackBar(context, 'Pilih tipe pencarian (SO, PO, PD) terlebih dahulu');
      return;
    }
    
    if (_salesOrderController.text.isEmpty) {
      _showSnackBar(context, 'Masukkan nomor $_selectedPrefix');
      return;
    }
    final searchValue = _salesOrderController.text;
    final fullCode = searchValue.startsWith(_selectedPrefix!) 
                      ? searchValue 
                      : '$_selectedPrefix$searchValue';
    
    _validateAndSetOrder(fullCode);
  }

  void _validateAndSetOrder(String code) {
    if (_dummyData[_selectedPrefix!]!.contains(code)) {
      setState(() {
        _currentSalesOrder = code;
        _scannedProducts.clear(); 
      });
      _showSnackBar(context, '$_selectedPrefix $code dipilih');
    } else {
      _showSnackBar(context, 'Kode $_selectedPrefix tidak ditemukan');
    }
  }

  void _addScannedProduct(String code) {
    if (!_dummyProducts.contains(code)) {
      _showSnackBar(context, 'Kode roll tidak ditemukan');
      return;
    }

    if (!_scannedProducts.contains(code)) {
      setState(() {
        _scannedProducts.add(code);
      });
    } else {
      _showSnackBar(context, 'Kode ini sudah di scan');
    }
  }
}