package com.mukminov.service.impl;

import com.mukminov.api.generated.dto.UserCreateDto;
import com.mukminov.api.generated.dto.UserDto;
import com.mukminov.entity.Role;
import com.mukminov.entity.User;
import com.mukminov.repository.RoleRepository;
import com.mukminov.repository.UserRepository;
import com.mukminov.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional(readOnly = true)
    public List<UserDto> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public UserDto getUserById(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Пользователь не найден"));
        return mapToDto(user);
    }

    @Override
    @Transactional
    public UserDto createUser(UserCreateDto createDto) {
        Role menteeRole = roleRepository.findByName("ROLE_MENTEE")
                .orElseGet(() -> roleRepository.save(Role.builder().name("ROLE_MENTEE").build()));

        User user = User.builder()
                .username(createDto.getUsername())
                .password(passwordEncoder.encode(createDto.getPassword()))
                .email(createDto.getEmail())
                .githubUsername(createDto.getGithubUsername())
                .build();

        user.getRoles().add(menteeRole);

        User savedUser = userRepository.save(user);
        return mapToDto(savedUser);
    }

    @Override
    @Transactional
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    private UserDto mapToDto(User user) {
        UserDto dto = new UserDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setGithubUsername(user.getGithubUsername());
        return dto;
    }
}