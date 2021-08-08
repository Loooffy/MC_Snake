require 'cls'

function cross(va, vb)
    cross_product = {
        x = va['y']*vb['z'] - va['z']*vb['y'],
        y = va['z']*vb['x'] - va['x']*vb['z'],
        z = va['x']*vb['y'] - va['y']*vb['x']
    }

    return cross_product
end

class 'Snake'
{
    __init__ = function(self, x, y, z)
        self.x = x
        self.y = y
        self.z = z
        self.vector = {
            x = 1,
            y = 0,
            z = 0,
        }
        self.cw_vector = {
            x = 0,
            y = 1,
            z = 0
        }
        self.ccw_vector = {
            x = 0,
            y = -1,
            z = 0
        }
    end;

    set_block = function(self)
        command = string.format('setblock %s %s %s stone', self.x, self.y, self.z)
        exec(command)
    end;

    turn_cw = function(self)
        self.vector = cross(self.cw_vector, self.vector)
    end;
        
    turn_ccw = function(self)
        self.vector = cross(self.ccw_vector, self.vector)
    end;

    move_block = function(self)
        new_x = self.x + self.vector['x']
        new_y = self.y + self.vector['y']
        new_z = self.z + self.vector['z']

        origin_pos = string.format('%s %s %s', self.x, self.y, self.z)
        new_pos = string.format('%s %s %s', new_x, new_y, new_z)

        command = string.format('clone %s %s %s replace move', origin_pos, origin_pos, new_pos)
        exec(command)

        self.x = new_x
        self.y = new_y
        self.z = new_z
        print(command)
    end;
}

snake = Snake(-44, 4, -34)
snake:set_block()

while true do
    if redstone.getInput('back') == true then
        if redstone.getInput('right') == true then
            snake:turn_cw()
        elseif redstone.getInput('left') == true then
            snake:turn_ccw()
        end
        snake:move_block()
        os.sleep(1)
    end
end
