import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_flutter/src/business_layer/bloc/theme/theme_cubit.dart';
import 'package:news_app_flutter/src/data_layer/res/app_styles.dart';
import 'package:news_app_flutter/src/ui_layer/common/base_widget.dart';
import 'package:news_app_flutter/src/ui_layer/common/common_image_widget.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildProfileHeader(),
        const SizedBox(height: 20),
        _buildOptionsList(context),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildProfileImage(),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildName(),
                _buildEmail(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: CommonImageWidget(
        url: 'https://picsum.photos/200/300',
        height: 80.w,
        width: 80.w,
      ),
    );
  }

  _buildName() {
    return Text(
      'John Doe',
      style: AppStyles.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEmail() {
    return Text(
      'john.doe@gmail.com',
      style: AppStyles.caption,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildOptionItem(
          title: 'My Profile',
          icon: Icons.person_outline,
          onTap: () {},
        ),
        _buildOptionItem(
          title: 'Theme',
          icon: Icons.color_lens_outlined,
          onTap: () {
            showThemeSwitcherDialog(context);
          },
        ),
      ],
    );
  }

  _buildOptionItem(
      {required String title,
      required IconData icon,
      required Null Function() onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void showThemeSwitcherDialog(BuildContext context) async {
    var themeCubit = BlocProvider.of<ThemeCubit>(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                title: 'Light',
                icon: Icons.wb_sunny_outlined,
                isSelected: context.read<ThemeCubit>().state == ThemeMode.light,
                onTap: () {
                  themeCubit.changeTheme(ThemeMode.light);
                },
              ),
              _buildThemeOption(
                title: 'Dark',
                icon: Icons.nightlight_round,
                isSelected: context.read<ThemeCubit>().state == ThemeMode.dark,
                onTap: () {
                  themeCubit.changeTheme(ThemeMode.dark);
                },
              ),
              _buildThemeOption(
                title: 'System',
                icon: Icons.settings_outlined,
                isSelected:
                    context.read<ThemeCubit>().state == ThemeMode.system,
                onTap: () {
                  themeCubit.changeTheme(ThemeMode.system);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _buildThemeOption(
      {required String title,
      required IconData icon,
      bool isSelected = false,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: (isSelected) ? const Icon(Icons.check) : null,
      onTap: onTap,
    );
  }
}
