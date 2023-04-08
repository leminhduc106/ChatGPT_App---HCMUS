import 'package:chatgpt_app/cubit/setting/setting_cubit.dart';
import 'package:chatgpt_app/service/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                    print(state.isAutoRead);
                  },
                ),
              ),
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
