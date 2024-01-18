import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/product.dart';
import 'package:shopapp/Providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct = Provider.of<Products?>(context, listen: false)!
            .findById(productId)!;
      }
      _initValues = {
        'title': _editedProduct.title!,
        'description': _editedProduct.description!,
        'price': _editedProduct.price!.toString(),
        // 'imageUrl': _editedProduct.imageUrl!
        'imageUrl': '',
      };
      _imageUrlController.text = _editedProduct.imageUrl!;
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https') &&
          !_imageUrlController.text.endsWith('.jpg') &&
          !_imageUrlController.text.endsWith('.png') &&
          !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  // void _saveForm() {
    Future<void> _saveForm() async{
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
     try{ await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);}
          catch(error){
            await showDialog(
            context: context,
            builder: ((ctx) => AlertDialog(
                  title: const Text('An Error Occured'),
                  content: const Text('something went wrong!'),
                  actions: [TextButton(onPressed: (() =>Navigator.of(ctx).pop()), child: const Text('Okay'))],
                )));

          }
      //     .catchError((error) {
      //   return showDialog(
      //       context: context,
      //       builder: ((ctx) => AlertDialog(
      //             title: const Text('An Error Occured'),
      //             content: const Text('something went wrong!'),
      //             actions: [TextButton(onPressed: (() =>Navigator.of(ctx).pop()), child: const Text('Okay'))],
      //           )));
      // })
      // .then((_) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // });
      finally{
           setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
      }
    

    // Navigator.of(context).pop();

    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a value!'; //We can style error message @InputDecoration
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (newValue) => _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: newValue,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl),
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a Price!'; //We can style error message @InputDecoration
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number!';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero!';
                          }
                          return null;
                        },
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (newValue) => _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(newValue!),
                            imageUrl: _editedProduct.imageUrl),
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode:
                            _descriptionFocusNode, //to adapt multiline text
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a description!'; //We can style error message @InputDecoration
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long!'; //We can style error message @InputDecoration
                          }
                          return null;
                        },
                        onSaved: (newValue) => _editedProduct = Product(
                            isFavorite: _editedProduct.isFavorite,
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: newValue,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            )),
                            child: _imageUrlController.text.isEmpty
                                ? const Text(
                                    'Enter a URL') //We can do an extra check to check if the URL is a valid URL.
                                : FittedBox(
                                    child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  )),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initValues['imageUrl'],
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Provide an image URL!'; //We can style error message @InputDecoration
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please Enter a valid URL';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please Enter a valid URL format';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (newValue) => _editedProduct = Product(
                                  isFavorite: _editedProduct.isFavorite,
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue),
                              onFieldSubmitted: (_) => _saveForm(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
