import os

def create_bloc_files(page_name, use_bloc=True):
    # Chuyển đổi page_name sang dạng chữ thường, thêm dấu gạch dưới cho các từ
    snake_case_name = page_name.lower().replace(" ", "_")
    
    # Chuyển page_name sang dạng PascalCase cho tên lớp
    class_case_name = page_name.title().replace(" ", "")
    
    # Đường dẫn đến thư mục gốc module/{Tên của screen}
    base_folder_path = f"../../module/{snake_case_name}"
    
    # Tạo thư mục con bloc hoặc cubit, screen, và widget
    bloc_or_cubit_folder = os.path.join(base_folder_path, "bloc" if use_bloc else "cubit")
    screen_folder_path = os.path.join(base_folder_path, "screen")
    widget_folder_path = os.path.join(base_folder_path, "widgets")
    os.makedirs(bloc_or_cubit_folder, exist_ok=True)
    os.makedirs(screen_folder_path, exist_ok=True)
    os.makedirs(widget_folder_path, exist_ok=True)

    # Nội dung file bloc hoặc cubit
    if use_bloc:
        bloc_content = f"""
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part '{snake_case_name}_event.dart';
part '{snake_case_name}_state.dart';

class {class_case_name}Bloc extends Bloc<{class_case_name}Event, {class_case_name}State> {{
  {class_case_name}Bloc() : super({class_case_name}Initial());
}}
"""
        
        # Nội dung file event
        event_content = f"""
part of '{snake_case_name}_bloc.dart';

abstract class {class_case_name}Event extends Equatable {{
  const {class_case_name}Event();
  @override
  List<Object> get props => [];
}}
"""

        # Nội dung file state
        state_content = f"""
part of '{snake_case_name}_bloc.dart';

@immutable
abstract class {class_case_name}State extends Equatable {{
  const {class_case_name}State();
  @override
  List<Object> get props => [];
}}

class {class_case_name}Initial extends {class_case_name}State {{}}
"""
    else:
        # Nội dung file cubit
        bloc_content = f"""
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part '{snake_case_name}_state.dart';

class {class_case_name}Cubit extends Cubit<{class_case_name}State> {{
  {class_case_name}Cubit() : super({class_case_name}Initial());
}}
"""

        # Nội dung file event không cần cho cubit
        event_content = ""

        # Nội dung file state
        state_content = f"""
part of '{snake_case_name}_cubit.dart';

@immutable
abstract class {class_case_name}State extends Equatable {{
  const {class_case_name}State();
  @override
  List<Object> get props => [];
}}

class {class_case_name}Initial extends {class_case_name}State {{}}
"""

    # Nội dung file screen với BlocProvider
    provider_type = "BlocProvider"
    bloc_class = f"{class_case_name}Bloc" if use_bloc else f"{class_case_name}Cubit"
    file_extension = "bloc" if use_bloc else "cubit"
    screen_content = f"""
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../{file_extension}/{snake_case_name}_{file_extension}.dart';
import '{snake_case_name}_body.dart';

class {class_case_name}Screen extends StatelessWidget {{
  const {class_case_name}Screen({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: Text('{class_case_name} Screen'),
      ),
      body: {provider_type}(
        create: (context) => {bloc_class}(),
        child: const {class_case_name}Body(),
      ),
    );
  }}
}}
"""

    # Nội dung file body với BlocConsumer cho cả Bloc và Cubit
    body_content = f"""
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../{file_extension}/{snake_case_name}_{file_extension}.dart';
import '../widgets/custom_text.dart';

class {class_case_name}Body extends StatelessWidget {{
  const {class_case_name}Body({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return BlocConsumer<{bloc_class}, {class_case_name}State>(
      listener: (context, state) {{}},
      builder: (context, state) {{
        return Center(
          child: CustomText(text: 'This is the {class_case_name} Body'),
        );
      }},
    );
  }}
}}
"""

    # Nội dung file custom_text cho widget
    custom_text_content = f"""
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {{
  final String text;

  const CustomText({{super.key, required this.text}});

  @override
  Widget build(BuildContext context) {{
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }}
}}
"""

    # Tạo file bloc hoặc cubit
    with open(f"{bloc_or_cubit_folder}/{snake_case_name}_{file_extension}.dart", "w") as f:
        f.write(bloc_content)

    # Tạo file event nếu dùng bloc
    if use_bloc:
        with open(f"{bloc_or_cubit_folder}/{snake_case_name}_event.dart", "w") as f:
            f.write(event_content)

    # Tạo file state
    with open(f"{bloc_or_cubit_folder}/{snake_case_name}_state.dart", "w") as f:
        f.write(state_content)
        
    # Tạo file screen
    with open(f"{screen_folder_path}/{snake_case_name}_screen.dart", "w") as f:
        f.write(screen_content)

    # Tạo file body
    with open(f"{screen_folder_path}/{snake_case_name}_body.dart", "w") as f:
        f.write(body_content)

    # Tạo file custom_text trong thư mục widget
    with open(f"{widget_folder_path}/custom_text.dart", "w") as f:
        f.write(custom_text_content)

    print(f"Created {page_name} {'Bloc' if use_bloc else 'Cubit'} files in {bloc_or_cubit_folder}; Screen, Body in {screen_folder_path}; and CustomText in {widget_folder_path}")


if __name__ == "__main__":
    # Nhập tên trang từ người dùng
    page_name = input("Enter the name of the page (e.g., Profile Page): ")
    choice = input("Choose 1 for Bloc or 2 for Cubit: ")

    use_bloc = choice == "1"
    create_bloc_files(page_name, use_bloc)
