from src.utilities_temp import add


def test_add_1():
    # Arrange.
    x = 2
    y = 3

    # Act.
    observed_z = add(x, y)

    # Assert.
    expected_z = 5
    assert observed_z == expected_z


def test_add_2():
    # Arrange.
    x = -2
    y = -3

    # Act.
    observed_z = add(x, y)

    # Assert.
    expected_z = -5
    assert observed_z == expected_z
