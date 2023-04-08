import 'package:chatgpt_app/cubit/setting/setting_cubit.dart';
import 'package:chatgpt_app/service/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final listItems = listLanguage.entries
        .map(
          (item) => DropdownMenuItem(
            value: item.value,
            child: Text(item.key),
          ),
        )
        .toList();
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: bgColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book_online_outlined),
                title: const Text('Auto read'),
                trailing: Switch(
                  value: state.isAutoRead,
                  onChanged: (value) {
                    context.read<SettingCubit>().toggleAutoRead();
                  },
                ),
              ),
              ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('Language'),
                  trailing: Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    height: 62,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          width: 112,
                          height: 36,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black26, width: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<String>(
                            elevation: 8,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            value: state.currentLanguage,
                            isExpanded: true,
                            items: listItems,
                            onChanged: (String? value) {
                              context
                                  .read<SettingCubit>()
                                  .changeLanguage(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear conversations'),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
