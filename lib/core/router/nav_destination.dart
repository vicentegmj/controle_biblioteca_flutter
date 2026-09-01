import 'package:flutter/material.dart';

class NavDestinationItem {
  const NavDestinationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const List<NavDestinationItem> kNavDestinations = [
  NavDestinationItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),
  NavDestinationItem(
    label: 'Novo Empréstimo',
    icon: Icons.add_box_outlined,
    selectedIcon: Icons.add_box,
  ),
  NavDestinationItem(
    label: 'Devolução',
    icon: Icons.assignment_return_outlined,
    selectedIcon: Icons.assignment_return,
  ),
  NavDestinationItem(
    label: 'Em Aberto',
    icon: Icons.folder_open_outlined,
    selectedIcon: Icons.folder_open,
  ),
  NavDestinationItem(
    label: 'Atrasados',
    icon: Icons.warning_amber_outlined,
    selectedIcon: Icons.warning_amber,
  ),
  NavDestinationItem(
    label: 'Histórico',
    icon: Icons.history_outlined,
    selectedIcon: Icons.history,
  ),
  NavDestinationItem(
    label: 'Configurações',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
  NavDestinationItem(
    label: 'Backup',
    icon: Icons.backup_outlined,
    selectedIcon: Icons.backup,
  ),
];
