part of 'image_picker_bloc.dart';

abstract class ImagePickerState extends Equatable {
  const ImagePickerState();

  @override
  List<Object> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class ImageLoadingState extends ImagePickerState {}

class ImageLoadedState extends ImagePickerState {
  String urlImage;
  File image;
  ImageLoadedState({this.urlImage, this.image});

  @override
  List<Object> get props => [urlImage];
}
