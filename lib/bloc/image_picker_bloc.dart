import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final UserService userService;
  ImagePickerBloc({@required this.userService}) : super(ImagePickerInitial());

  @override
  Stream<ImagePickerState> mapEventToState(
    ImagePickerEvent event,
  ) async* {
    if (event is PickImageEvent) {
      try {
        yield ImageLoadingState();
        yield await userService.getImage();
      } catch (err) {
        yield ImagePickerInitial();
      }
    }
  }
}
